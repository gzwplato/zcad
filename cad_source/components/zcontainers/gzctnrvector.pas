{
*****************************************************************************
*                                                                           *
*  This file is part of the ZCAD                                            *
*                                                                           *
*  See the file COPYING.modifiedLGPL.txt, included in this distribution,    *
*  for details about the copyright.                                         *
*                                                                           *
*  This program is distributed in the hope that it will be useful,          *
*  but WITHOUT ANY WARRANTY; without even the implied warranty of           *
*  MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.                     *
*                                                                           *
*****************************************************************************
}
{**
@author(Andrey Zubarev <zamtmn@yandex.ru>)
}
{**Модуль описания базового генерика обьекта-массива}
unit gzctnrvector;
{$INCLUDE def.inc}
interface
uses uzbmemman,uzbtypesbase,sysutils,uzbtypes,typinfo;
const
  {**типы нуждающиеся в инициализации}
  TypesNeedToFinalize=[tkUnknown{$IFNDEF DELPHI},tkSString{$ENDIF},tkLString{$IFNDEF DELPHI},tkAString{$ENDIF},
                       tkWString,tkVariant,tkRecord,tkInterface,
                       tkClass{$IFNDEF DELPHI},tkObject{$ENDIF},tkDynArray{$IFNDEF DELPHI},tkInterfaceRaw{$ENDIF},
                       tkUString{$IFNDEF DELPHI},tkUChar{$ENDIF}{$IFNDEF DELPHI},tkHelper{$ENDIF}{$IFNDEF DELPHI},tkFile{$ENDIF},tkClassRef];
  {**типы нуждающиеся в финализации}
  TypesNeedToInicialize=[tkUnknown{$IFNDEF DELPHI},tkSString{$ENDIF},tkLString{$IFNDEF DELPHI},tkAString{$ENDIF},
                         tkWString,tkVariant,tkRecord,tkInterface,
                         tkClass{$IFNDEF DELPHI},tkObject{$ENDIF},tkDynArray{$IFNDEF DELPHI},tkInterfaceRaw{$ENDIF},
                         tkUString{$IFNDEF DELPHI},tkUChar{$ENDIF}{$IFNDEF DELPHI},tkHelper{$ENDIF}{$IFNDEF DELPHI},tkFile{$ENDIF},tkClassRef];
type
{Export+}
{**Генерик объекта-массива}
GZVector{-}<T>{//}={$IFNDEF DELPHI}packed{$ENDIF}
  object(GDBaseObject)
    {-}type{//}
        {-}PT=^T;{//}                                     //**< Тип указатель на тип данных T
        {-}TArr=array[0..0] of T;{//}                     //**< Тип массив данных T
        {-}PTArr=^TArr;{//}                               //**< Тип указатель на массив данных T
        {-}TEqualFunc=function(const a, b: T):Boolean;{//}//**< Тип функция идентичности T
        {-}TProcessProc=procedure(const p: PT);{//}       //**< Тип процедура принимающая указатель на T
    {-}var{//}
        PArray:{-}PTArr{/GDBPointer/};(*hidden_in_objinsp*)   //**< Указатель на массив данных
        GUID:GDBString;(*hidden_in_objinsp*)                  //**< Шняга для подсчета куда уходит память. используется только с DEBUGBUILD. Надо чтото ч ней делать
        Count:TArrayIndex;(*hidden_in_objinsp*)               //**< Количество занятых элементов массива
        Max:TArrayIndex;(*hidden_in_objinsp*)                 //**< Размер массива (под сколько элементов выделено памяти)

        {**Деструктор}
        destructor done;virtual;
        {**Деструктор}
        destructor destroy;virtual;
        {**Конструктор}
        constructor init({$IFDEF DEBUGBUILD}ErrGuid:pansichar;{$ENDIF}m:TArrayIndex);
        {**Конструктор}
        constructor initnul;

        {**Удаление всех элементов массива}
        procedure free;virtual;

        {**Начало "перебора" элементов массива
          @param(ir переменная "итератор")
          @return(указатель на первый элемент массива)}
        function beginiterate(out ir:itrec):GDBPointer;virtual;
        {**"Перебор" элементов массива
          @param(ir переменная "итератор")
          @return(указатель на следующий элемент массива, nil если это конец)}
        function iterate(var ir:itrec):GDBPointer;virtual;

        function SetCount(index:GDBInteger):GDBPointer;virtual;
        {**Инвертировать массив}
        procedure Invert;
        {**Копировать в массив}
        function copyto(var source:GZVector<T>):GDBInteger;virtual;
        {**Выделяет место и копирует в массив SData элементов из PData. Надо compilermagic! соответствие с AllocData
          @PData(указатель на копируемые элементы)
          @SData(кол-во копируемых элементов)
          @return(индекс первого скопированного элемента в массиве)}
        function AddData(PData:GDBPointer;SData:GDBword):GDBInteger;virtual;
        {**Выделяет место в массиве под SData элементов. Надо compilermagic! соответствие с AddData
          @SData(кол-во копируемых элементов)
          @return(индекс первого выделенного элемента в массиве)}
        function AllocData(SData:GDBword):GDBInteger;virtual;


        {old}
        {**Удалить элемент по индексу}
        function DeleteElement(index:GDBInteger):GDBPointer;
        {**Перевод указателя в индекс}
        function P2I(pel:GDBPointer):GDBInteger;
        {**Удалить элемент по указателю}
        function DeleteElementByP(pel:GDBPointer):GDBPointer;
        {**вставить элемент}
        function InsertElement(index:GDBInteger;const data:T):GDBPointer;

        {need compilermagic}
        procedure Grow(newmax:GDBInteger=0);virtual;
        {**Выделяет память под массив}
        function CreateArray:GDBPointer;virtual;

        {reworked}
        {**Устанавливает длину массива}
        procedure SetSize(nsize:TArrayIndex);
        {**Возвращает указатель на значение по индексу}
        function getDataMutable(index:TArrayIndex):PT;
        {**Возвращает значение по индексу}
        function getData(index:TArrayIndex):T;
        {**Добавить в конец массива значение, возвращает индекс добавленного значения}
        function PushBackData(const data:T):TArrayIndex;
        {**Добавить в конец массива значение если его еще нет в массиве, возвращает индекс найденного или добавленного значения}
        function PushBackIfNotPresentWithCompareProc(data:T;EqualFunc:TEqualFunc):GDBInteger;
        {**Добавить в конец массива значение если оно еще не в конце массива, возвращает индекс найденного или добавленного значения}
        function PushBackIfNotLastWithCompareProc(data:T;EqualFunc:TEqualFunc):GDBInteger;
        {**Добавить в конец массива значение если оно еще не в конце массива или не в начале масива, возвращает индекс найденного или добавленного значения}
        function PushBackIfNotLastOrFirstWithCompareProc(data:T;EqualFunc:TEqualFunc):GDBInteger;
        {**Проверка нахождения в массиве значения с функцией сравнения}
        function IsDataExistWithCompareProc(pobj:T;EqualFunc:TEqualFunc):GDBInteger;
        {**Возвращает тип элемента массива}
        function GetSpecializedTypeInfo:PTypeInfo;inline;

        {**Возвращает размер элемента массива}
        function SizeOfData:TArrayIndex;
        {**Возвращает указатель на массив}
        function GetParrayAsPointer:pointer;
        {**Очищает массив не убивая элементы, просто count:=0}
        procedure Clear;virtual;
        {**Возвращает реальное колво элементов, в данном случае=count}
        function GetRealCount:GDBInteger;
        {**Возвращает колво элементов}
        function GetCount:GDBInteger;
        {**Подрезать выделенную память по count}
        procedure Shrink;virtual;
  end;
{Export-}
implementation
function GZVector<T>.GetSpecializedTypeInfo:PTypeInfo;
begin
  result:=TypeInfo(T);
end;

function GZVector<T>.getDataMutable;
begin
     if (index>=max)
        or(index<0)then
                     result:=nil
else if PArray=nil then
                     result:=nil
                   else
                     result:=@parray[index];
end;
function GZVector<T>.getData;
begin
     if (index>=max)
        or(index<0)then
                     result:=default(T)
else if PArray=nil then
                     result:=default(T)
                   else
                     result:=parray[index];
end;
function GZVector<T>.PushBackData(const data:T):TArrayIndex;
begin
  if parray=nil then
                     CreateArray;
  if count = max then
                     grow;
  begin
       if PTypeInfo(TypeInfo(T))^.kind in TypesNeedToInicialize
          then fillchar(parray[count],sizeof(T),0);
       parray[count]:=data;
       result:=count;
       inc(count);
  end;
end;
function GZVector<T>.GetParrayAsPointer;
begin
  result:=pointer(parray);
end;

function GZVector<T>.IsDataExistWithCompareProc;
var i:integer;
begin
     for i:=0 to count-1 do
     if EqualFunc(parray[i],pobj) then
                           begin
                                result:=i;
                                exit;
                           end;
     result:=-1;
end;
function GZVector<T>.PushBackIfNotLastWithCompareProc(data:T;EqualFunc:TEqualFunc):GDBInteger;
begin
  if count>0 then
  begin
    if not EqualFunc(parray[count-1],data) then
      result:=PushBackData(data)
    else
      result:=count-1;
  end
  else
    result:=PushBackData(data);
end;
function GZVector<T>.PushBackIfNotLastOrFirstWithCompareProc(data:T;EqualFunc:TEqualFunc):GDBInteger;
begin
  if count>0 then
  begin
    if not EqualFunc(parray[count-1],data) then
    begin
      if not EqualFunc(parray[0],data) then
        result:=PushBackData(data)
      else
        result:=0;
    end
    else
      result:=count-1;
  end
  else
    result:=PushBackData(data);
end;
function GZVector<T>.PushBackIfNotPresentWithCompareProc;
begin
  result:=IsDataExistWithCompareProc(data,EqualFunc);
  if result=-1 then
                   result:=PushBackData(data);
  {if IsDataExistWithCompareProc(data,EqualFunc)>=0 then
                                                   begin
                                                        result := -1;
                                                        exit;
                                                   end;
  result:=PushBackData(data);}
end;
function GZVector<T>.AllocData(SData:GDBword):GDBInteger;
begin
  if parray=nil then
                    createarray;
  if count+sdata>max then
                         Grow((count+sdata)*2);
  result:={@parray^[}count{]};
  //result:=pointer(GDBPlatformUInt(parray)+count*SizeOfData);
  {$IFDEF FILL0ALLOCATEDMEMORY}
  fillchar(result^,sdata,0);
  {$ENDIF}
  inc(count,SData);
end;
function GZVector<T>.AddData(PData:GDBPointer;SData:GDBword):GDBInteger;
var addr:GDBpointer;
begin
  if parray=nil then
                    createarray;
  if count+sdata>max then
                         begin
                              if count+sdata>2*max then
                                                       {Grow}SetSize(count+sdata)
                                                   else
                                                        Grow;
                         end;
  {if count = max then
                     begin
                          parray := enlargememblock(parray, size * max, 2*size * max);
                          max:=2*max;
                     end;}
  begin
       //GDBPointer(addr) := parray;
       //addr := addr + count;
       { TODO : Надо копировать  с учетом compiler magic а не тупо мовить }
       addr:=@parray^[count];
       Move(PData^, addr^,SData*SizeOfData);
       result:=count;
       inc(count,SData);
  end;
end;
function GZVector<T>.GetRealCount:GDBInteger;
{var p:GDBPointer;
    ir:itrec;}
begin
  result:=GetCount;
  {p:=beginiterate(ir);
  if p<>nil then
  repeat
        inc(result);
        p:=iterate(ir);
  until p=nil;}
end;
function GZVector<T>.copyto(var source:GZVector<T>):GDBInteger;
var i:integer;
begin
     result:=count;
     for i:=0 to count-1 do
       source.PushBackData(parray[i]);
end;

{var p:pt;
    ir:itrec;
begin
  p:=beginiterate(ir);
  if p<>nil then
  repeat
        source.PushBackData(p^);  //-----------------//-----------
        p:=iterate(ir);
  until p=nil;
  result:=count;
end;}
procedure GZVector<T>.Invert;
(*var p,pl,tp:GDBPointer;
    ir:itrec;
begin
  p:=beginiterate(ir);
  p:=getDataMutable(0);
  pl:=getDataMutable(count-1);
  GDBGetMem({$IFDEF DEBUGBUILD}'{D9D91D43-BD6A-450A-B07E-E964425E7C99}',{$ENDIF}tp,SizeOfData);
  if p<>nil then
  repeat
        if GDBPlatformUInt(pl)<=GDBPlatformUInt(p) then
                                         break;
        Move(p^,tp^,SizeOfData);
        Move(pl^,p^,SizeOfData);
        Move(tp^,pl^,SizeOfData);
        dec(GDBPlatformUInt(pl),SizeOfData);
        inc(GDBPlatformUInt(p),SizeOfData);
  until false;
  GDBFreeMem(tp);
end;*)
var i,j:integer;
    tdata:t;
begin
  j:=count-1;
  for i:=0 to (count-1)div 2 do
  begin
       tdata:=parray^[i];
       parray^[i]:=parray^[j];
       parray^[j]:=tdata;
       dec(j);
  end;
end;

function GZVector<T>.SetCount;
begin
     count:=index;
     if parray=nil then
                        createarray;
     if count>=max then
                       begin
                            if count>2*max then
                                               SetSize(2*count)
                                           else
                                               SetSize(2*max);
                       end;
     result:=parray;
end;
procedure GZVector<T>.SetSize;
begin
     if nsize>max then
                      begin
                           parray := enlargememblock({$IFDEF DEBUGBUILD}@Guid[1],{$ENDIF}parray, SizeOfData*max, SizeOfData*nsize);
                      end
else if nsize<max then
                      begin
                           parray := enlargememblock({$IFDEF DEBUGBUILD}@Guid[1],{$ENDIF}parray, SizeOfData*max, SizeOfData*nsize);
                           if count>nsize then count:=nsize;
                      end;
     max:=nsize;
end;
function GZVector<T>.beginiterate;
begin
  if parray=nil then
                    result:=nil
                else
                    begin
                          {ir.itp:=pointer(GDBPlatformUInt(parray)-SizeOfData);}
                          ir.itp:=pointer(parray);
                          dec(pt(ir.itp));
                          ir.itc:=-1;
                          result:=iterate(ir);
                    end;
end;
function GZVector<T>.iterate;
begin
  if count=0 then result:=nil
  else if ir.itc<(count-1) then
                      begin
                           inc(pGDBByte(ir.itp),SizeOfData);
                           inc(ir.itc);

                           result:=ir.itp;
                      end
                  else result:=nil;
end;
constructor GZVector<T>.initnul;
begin
  PArray:=nil;
  pointer(GUID):=nil;
  Count:=0;
  Max:=0;
end;
constructor GZVector<T>.init;
begin
  PArray:=nil;
  pointer(GUID):=nil;
  Count:=0;
  Max:=m;
  {$IFDEF DEBUGBUILD}Guid:=ErrGuid;{$ENDIF}
end;
destructor GZVector<T>.done;
begin
  free;
  destroy;
end;
destructor GZVector<T>.destroy;
begin
  if PArray<>nil then
                     GDBFreeMem(PArray);
  PArray:=nil;
  {$IFDEF DEBUGBUILD}Guid:='';{$ENDIF}
end;
procedure GZVector<T>.free;
var i:integer;
   _pt:PTypeInfo;
begin
 _pt:=TypeInfo(T);
     if _pt^.Kind in TypesNeedToFinalize then
       for i:=0 to count-1 do
                             PArray^[i]:=default(t);
  count:=0;
end;
function GZVector<T>.SizeOfData:TArrayIndex;
begin
  result:=sizeof(T);
end;
procedure GZVector<T>.clear;
begin
  count:=0;
end;
function GZVector<T>.CreateArray;
begin
  GDBGetMem({$IFDEF DEBUGBUILD}@Guid[1],{$ENDIF}PArray,SizeOfData*max);
  result:=parray;
end;
procedure GZVector<T>.Grow;
begin
     if newmax<=0 then
                     newmax:=2*max;
     parray := enlargememblock({$IFDEF DEBUGBUILD}@Guid[1],{$ENDIF}parray, SizeOfData * max, SizeOfData * newmax);
     max:=newmax;
end;
procedure GZVector<T>.Shrink;
begin
  if (count<>0)and(count<max) then
  begin
       parray := remapmememblock({$IFDEF DEBUGBUILD}@Guid[1],{$ENDIF}parray, SizeOfData * count);
       max := count;
  end;
end;
function GZVector<T>.GetCount:GDBInteger;
begin
  result:=count;
end;
function GZVector<T>.InsertElement;
{var
   s:integer;}
begin
     if index=count then
                        PushBackData(data)
                    else
     begin
       if parray=nil then
                          CreateArray;
       if count = max then
                          grow;
       Move(parray[index],parray[index+1],(count-index)*sizeof(t));
       if PTypeInfo(TypeInfo(T))^.kind in TypesNeedToInicialize
               then fillchar(parray[index],sizeof(T),0);
       parray[index]:=data;
       inc(count);
     end;
     result:=parray;
end;
function GZVector<T>.DeleteElement;
begin
  if (index>=0)and(index<count)then
  begin
    dec(count);
    if PTypeInfo(TypeInfo(T))^.kind in TypesNeedToInicialize
      then parray^[index]:=default(t);
    if index<>count then
    Move(parray^[index+1],parray^[index],(count-index)*SizeOfData);
  end;
  result:=parray;
end;
function GZVector<T>.P2I(pel:GDBPointer):GDBInteger;
begin
  result:=PT(pel)-PT(parray);
end;
function GZVector<T>.DeleteElementByP;
var
   s:integer;
begin
  deleteelement(p2i(pel));
  {s:=PT(pel)-PT(parray);
  if s>=0 then
  begin
    deleteelement(s);
  end;
  result:=parray;}
end;
begin
end.
