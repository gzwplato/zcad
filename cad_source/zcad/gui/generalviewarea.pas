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
{
@author(Andrey Zubarev <zamtmn@yandex.ru>) 
}

unit generalviewarea;
{$INCLUDE def.inc}
interface
uses
     log,zemathutils,gdbpalette,
     geometry,gdbase,gdbasetypes,UGDBSelectedObjArray,
     UGDBLayerArray,ugdbdimstylearray,
     oglwindowdef,gdbdrawcontext,varmandef,zcadsysvars,GDBEntity,zcadinterface,ugdbabstractdrawing,UGDBPoint3DArray,UGDBEntTree,
     gdbobjectsconstdef,shared,zcadstrconsts,UGDBTracePropArray,math,sysutils,commandlinedef,UGDBDrawingdef,strproc,
     ExtCtrls,Controls,Classes,LCLType,Forms,UGDBOpenArrayOfPV,GDBGenericSubEntry,GDBCamera,UGDBVisibleOpenArray,uzglabstractdrawer,uzglgeneraldrawer,abstractviewarea;
const
  ontracdist=10;
  ontracignoredist=25;

type
    TCameraChangedNotify=procedure of object;
    TGeneralViewArea=class(TAbstractViewArea)
                           public
                           WorkArea:TCADControl;
                           InsidePaintMessage:integer;
                           {param: OGLWndtype;
                           PDWG:PTAbstractDrawing;
                           PolarAxis:GDBPoint3dArray;
                           OTTimer:TTimer;
                           OHTimer:TTimer;
                           tocommandmcliccount:GDBInteger;
                           currentmousemovesnaptogrid:GDBBoolean;

                           onCameraChanged:TCameraChangedNotify;
                           ShowCXMenu:procedure of object;
                           MainMouseMove:procedure of object;
                           MainMouseDown:function:boolean of object;}

                           function getviewcontrol:TCADControl;override;


                           procedure calcgrid;override;
                           procedure Clear0Ontrackpoint;override;
                           procedure ClearOntrackpoint;override;
                           procedure SetMouseMode(smode:GDBByte);override;
                           procedure SetObjInsp;override;
                           procedure sendcoordtocommandTraceOn(coord:GDBVertex;key: GDBByte;pos:pos_record);override;
                           procedure reprojectaxis;override;
                           procedure Project0Axis;override;
                           procedure create0axis;override;
                           procedure ZoomToVolume(Volume:TBoundingBox);override;
                           procedure ZoomAll;override;
                           procedure ZoomSel;override;
                           procedure RotTo(x0,y0,z0:GDBVertex);override;
                           procedure PanScreen(oldX,oldY,X,Y:Integer);override;
                           procedure RestoreMouse;override;
                           procedure myKeyPress(var Key: Word; Shift: TShiftState);override;
                           function ProjectPoint(pntx,pnty,pntz:gdbdouble;var wcsLBN,wcsRTF,dcsLBN,dcsRTF: GDBVertex):gdbvertex;override;
                           procedure mouseunproject(X, Y: integer);override;
                           //Procedure Paint;override;
                           procedure addaxistootrack(var posr:os_record;const axis:GDBVertex);virtual;
                           procedure projectaxis;override;
                           procedure CalcOptimalMatrix;override;
                           procedure SetOGLMatrix;virtual;
                           procedure CalcMouseFrustum;override;
                           procedure ProcOTrackTimer(Sender:TObject);override;
                           procedure KillOTrackTimer(Sender: TObject);override;
                           procedure SetOTrackTimer(Sender: TObject);override;
                           procedure KillOHintTimer(Sender: TObject);override;
                           procedure SetOHintTimer(Sender: TObject);override;
                           procedure getosnappoint(radius: GDBFloat);override;
                           procedure getonmouseobject(pva: PGDBObjEntityOpenArray);virtual;
                           function findonmobj(pva: PGDBObjEntityOpenArray; var i: GDBInteger): GDBInteger;virtual;
                           procedure getonmouseobjectbytree(Node:TEntTreeNode);override;
                           procedure processmousenode(Node:TEntTreeNode;var i:integer);virtual;
                           procedure AddOntrackpoint;override;
                           procedure CorrectMouseAfterOS;override;
                           function CreateRC(_maxdetail:GDBBoolean=false):TDrawContext;override;
                           procedure sendcoordtocommand(coord:GDBVertex;key: GDBByte);virtual;
                           procedure sendmousecoordwop(key: GDBByte);override;
                           procedure sendmousecoord(key: GDBByte);override;
                           procedure asynczoomsel(Data: PtrInt);
                           procedure asynczoomall(Data: PtrInt);
                           procedure asyncupdatemouse(Data: PtrInt);override;
                           procedure set3dmouse;override;
                           procedure SetCameraPosZoom(_pos:gdbvertex;_zoom:gdbdouble;finalcalk:gdbboolean);override;
                           procedure DISP_ZoomFactor(x: double{; MousePos: TPoint});
                           procedure showmousecursor;override;
                           procedure hidemousecursor;override;
                           Procedure Paint; override;
                           function treerender(var Node:TEntTreeNode;StartTime:TDateTime;var DC:TDrawContext):GDBBoolean; override;
                           procedure render(const Root:GDBObjGenericSubEntry;var DC:TDrawContext); override;
                           procedure finishdraw(var RC:TDrawContext); override;
                           procedure draw;override;
                           procedure DrawOrInvalidate;override;
                           procedure showcursor(var DC:TDrawContext);override;
                           procedure DrawCSAxis(var DC:TDrawContext);
                           procedure SwapBuffers(var DC:TDrawContext);override;
                           procedure DrawGrid(var DC:TDrawContext);override;
                           procedure LightOn(var DC:TDrawContext);override;
                           procedure LightOff(var DC:TDrawContext);override;
                           procedure GDBActivate;override;


                           procedure showsnap(var DC:TDrawContext); virtual;


                           {onЧетоТам обработчики событй рабочей области}
                           procedure WaMouseUp(Sender:TObject;Button: TMouseButton; Shift:TShiftState;X, Y: Integer);
                           procedure WaMouseDown(Sender:TObject;Button: TMouseButton; Shift: TShiftState;X, Y: Integer);
                           procedure WaMouseMove(sender:tobject;Shift: TShiftState; X, Y: Integer);override;
                           procedure WaMouseWheel(Sender:TObject;Shift: TShiftState; WheelDelta: Integer;MousePos: TPoint;var handled:boolean);
                           procedure WaMouseEnter(Sender:TObject);
                           procedure WaMouseLeave(Sender:TObject);
                           procedure WaResize(sender:tobject); override;
                           procedure mypaint(sender:tobject);


                           constructor Create(TheOwner: TComponent); override;
                           destructor Destroy; override;
                           function CreateWorkArea(TheOwner: TComponent):TCADControl; virtual;abstract;
                           procedure CreateDrawer; virtual;abstract;
                           procedure SetupWorkArea; virtual;abstract;
                           procedure doCameraChanged; override;
                           function startpaint:boolean;override;
                           procedure endpaint;override;
                           function NeedDrawInsidePaintEvent:boolean; virtual;abstract;
                           procedure ZoomIn;override;
                           procedure ZoomOut;override;
                      end;
implementation
uses
     commandline;
procedure TGeneralViewArea.mypaint;
begin
     //param.firstdraw:=true;
     inc(InsidePaintMessage);
     draw;
     dec(InsidePaintMessage);
     inherited;
end;
procedure TGeneralViewArea.ZoomIn;
begin
     getviewcontrol.DoMouseWheel([],1,point(0,0));
end;
procedure TGeneralViewArea.ZoomOut;
begin
     getviewcontrol.DoMouseWheel([],-1,point(0,0));
end;
procedure TGeneralViewArea.GDBActivate;
begin
    pdwg.SetCurrentDWG;
    param.firstdraw:=true;
    GDBActivateGLContext;
    //paint;
    getviewcontrol.invalidate;
  if assigned(updatevisibleproc) then updatevisibleproc;
end;
procedure drawfrustustum(frustum:ClipArray;var DC:TDrawContext);
var
tv1,tv2,tv3,tv4{,sv1,sv2,sv3,sv4,d1PProjPoint{,d2,d3,d4}:gdbvertex;
Tempplane:DVector4D;

begin
  Tempplane:=frustum[5];
  tempplane[3]:=(tempplane[3]-frustum[4][3])/2;
  begin
  tv1:=PointOf3PlaneIntersect(frustum[0],frustum[3],Tempplane);
  tv2:=PointOf3PlaneIntersect(frustum[1],frustum[3],Tempplane);
  tv3:=PointOf3PlaneIntersect(frustum[1],frustum[2],Tempplane);
  tv4:=PointOf3PlaneIntersect(frustum[0],frustum[2],Tempplane);
  {oglsm.myglbegin(GL_LINES);
                 oglsm.myglVertex3dv(@tv1);
                 oglsm.myglVertex3dv(@tv2);
                 oglsm.myglVertex3dv(@tv2);
                 oglsm.myglVertex3dv(@tv3);
                 oglsm.myglVertex3dv(@tv3);
                 oglsm.myglVertex3dv(@tv4);
                 oglsm.myglVertex3dv(@tv4);
                 oglsm.myglVertex3dv(@tv1);
  oglsm.myglend;}
  dc.drawer.DrawLine3DInModelSpace(tv1,tv2,dc.matrixs);
  dc.drawer.DrawLine3DInModelSpace(tv2,tv3,dc.matrixs);
  dc.drawer.DrawLine3DInModelSpace(tv3,tv4,dc.matrixs);
  dc.drawer.DrawLine3DInModelSpace(tv4,tv1,dc.matrixs);
  end;
end;
procedure TGeneralViewArea.showcursor(var DC:TDrawContext);
var
  i, j: GDBInteger;
  pt:ptraceprop;
  mvertex,dvertex,tv1,tv2,sv1,d1:gdbvertex;
  Tempplane,plx,ply,plz:DVector4D;
  a: GDBInteger;
  i2d,i2dresult:intercept2dprop;
  _NotUseLCS:boolean;
begin
  if param.scrollmode then
                          exit;
  CalcOptimalMatrix;
  dc.drawer.startrender(TRM_ModelSpace,dc.matrixs);
  if PDWG.GetSelObjArray.Count<>0 then
                                      begin
                                        PDWG.GetSelObjArray.drawpoint(dc);
                                        if param.gluetocp then
                                        begin
                                          dc.drawer.SetColor(palette[sysvar.DISP.DISP_HotGripColor^].rgb);
                                          dc.drawer.SetPointSize(sysvar.DISP.DISP_GripSize^);
                                          dc.drawer.DrawPoint3DInModelSpace(param.md.mouse3dcoord,dc.matrixs);
                                          dc.drawer.SetPointSize(1);
                                        end;
                                      end;
  dc.drawer.SetColor(255, 255, 255,255);
  {oglsm.myglEnable(GL_COLOR_LOGIC_OP);
  oglsm.myglLogicOp(GL_OR);}
  dc.drawer.SetDrawMode(TDM_OR);
  if param.ShowDebugFrustum then
                          drawfrustustum(param.debugfrustum,dc);
  {if param.ShowDebugBoundingBbox then
                              DrawAABB(param.DebugBoundingBbox);}

  Tempplane:=param.mousefrustumLCS[5];
  tempplane[3]:=(tempplane[3]-param.mousefrustumLCS[4][3])/2;
  {курсор фрустума выделения}
  if param.md.mousein then
  if (param.md.mode and MGetSelectObject) <> 0 then
  begin
  _NotUseLCS:=NotUseLCS;
  NotUseLCS:=true;
  drawfrustustum(param.mousefrustumLCS,dc);
  NotUseLCS:=_NotUseLCS;
  end;
  {оси курсора}
  _NotUseLCS:=NotUseLCS;
  NotUseLCS:=true;
  if param.md.mousein then
  if ((param.md.mode)and(MGet3DPoint or MGet3DPointWoOP or MGetControlpoint))<> 0 then
  begin
  sv1:=param.md.mouseray.lbegin;
  sv1:=vertexadd(sv1,PDWG.Getpcamera^.CamCSOffset);

  PointOfLinePlaneIntersect(VertexAdd(param.md.mouseray.lbegin,PDWG.Getpcamera^.CamCSOffset),param.md.mouseray.dir,tempplane,mvertex);
  plx:=PlaneFrom3Pont(sv1,vertexadd(param.md.mouse3dcoord,PDWG.Getpcamera^.CamCSOffset),
                      vertexadd(VertexAdd(param.md.mouse3dcoord,xWCS{VertexMulOnSc(xWCS,oneVertexlength(wa.param.md.mouse3dcoord))}),PDWG.Getpcamera^.CamCSOffset));
  if assigned(sysvar.DISP.DISP_ColorAxis)then
  if sysvar.DISP.DISP_ColorAxis^ then dc.drawer.SetColor(255, 0, 0,255);
  tv1:=PointOf3PlaneIntersect(PDWG.Getpcamera.frustumLCS[0],plx,Tempplane);
  tv2:=PointOf3PlaneIntersect(PDWG.Getpcamera.frustumLCS[1],plx,Tempplane);
  dvertex:=geometry.VertexSub(tv2,tv1);
  dvertex:=geometry.VertexMulOnSc(dvertex,SysVar.DISP.DISP_CrosshairSize^);
  tv1:=VertexSub(mvertex,dvertex);
  tv2:=VertexAdd(mvertex,dvertex);
  dc.drawer.DrawLine3DInModelSpace(tv1,tv2,dc.matrixs);

  ply:=PlaneFrom3Pont(sv1,vertexadd(param.md.mouse3dcoord,PDWG.Getpcamera^.CamCSOffset),
                      vertexadd(VertexAdd(param.md.mouse3dcoord,yWCS{VertexMulOnSc(xWCS,oneVertexlength(wa.param.md.mouse3dcoord))}),PDWG.Getpcamera^.CamCSOffset));
  if assigned(sysvar.DISP.DISP_ColorAxis)then
  if sysvar.DISP.DISP_ColorAxis^ then dc.drawer.SetColor(0, 255, 0,255);
  tv1:=PointOf3PlaneIntersect(PDWG.Getpcamera.frustumLCS[2],ply,Tempplane);
  tv2:=PointOf3PlaneIntersect(PDWG.Getpcamera.frustumLCS[3],ply,Tempplane);
  dvertex:=geometry.VertexSub(tv2,tv1);
  dvertex:=geometry.VertexMulOnSc(dvertex,SysVar.DISP.DISP_CrosshairSize^*{gdb.GetCurrentDWG.OGLwindow1.}getviewcontrol.ClientWidth/{gdb.GetCurrentDWG.OGLwindow1.}getviewcontrol.ClientHeight);
  tv1:=VertexSub(mvertex,dvertex);
  tv2:=VertexAdd(mvertex,dvertex);
  dc.drawer.DrawLine3DInModelSpace(tv1,tv2,dc.matrixs);

  if assigned(sysvar.DISP.DISP_DrawZAxis)then
  if sysvar.DISP.DISP_DrawZAxis^ then
  begin
  plz:=PlaneFrom3Pont(sv1,vertexadd(param.md.mouse3dcoord,PDWG.Getpcamera^.CamCSOffset),
                      vertexadd(VertexAdd(param.md.mouse3dcoord,zWCS{VertexMulOnSc(xWCS,oneVertexlength(wa.param.md.mouse3dcoord))}),PDWG.Getpcamera^.CamCSOffset));
  if assigned(sysvar.DISP.DISP_ColorAxis)then
  if sysvar.DISP.DISP_ColorAxis^ then dc.drawer.SetColor(0, 0, 255,255);
  tv1:=PointOf3PlaneIntersect(PDWG.Getpcamera.frustumLCS[0],plz,Tempplane);
  tv2:=PointOf3PlaneIntersect(PDWG.Getpcamera.frustumLCS[1],plz,Tempplane);
  dvertex:=geometry.VertexSub(tv2,tv1);
  dvertex:=geometry.VertexMulOnSc(dvertex,SysVar.DISP.DISP_CrosshairSize^);
  tv1:=VertexSub(mvertex,dvertex);
  tv2:=VertexAdd(mvertex,dvertex);
  dc.drawer.DrawLine3DInModelSpace(tv1,tv2,dc.matrixs);
  end;
  end;
  dc.drawer.SetColor(255, 255, 255,255);
  d1:=geometry.VertexAdd(param.md.mouseray.lbegin,param.md.mouseray.lend);
  d1:=geometry.VertexMulOnSc(d1,0.5);


  dc.drawer.startrender(TRM_DisplaySpace,dc.matrixs);
  //dc.drawer.SetDisplayCSmode(getviewcontrol.clientwidth, getviewcontrol.clientheight);
  {oglsm.myglMatrixMode(GL_PROJECTION);
  oglsm.myglLoadIdentity;
  oglsm.myglOrtho(0.0, getviewcontrol.clientwidth, getviewcontrol.clientheight, 0.0, -1.0, 1.0);
  oglsm.myglMatrixMode(GL_MODELVIEW);
  oglsm.myglLoadIdentity;
  oglsm.myglscalef(1, -1, 1);
  oglsm.myglpushmatrix;
  oglsm.mygltranslated(0, -getviewcontrol.clientheight, 0);}

  if param.lastonmouseobject<>nil then
                                      pGDBObjEntity(param.lastonmouseobject)^.higlight(dc);

  (*oglsm.myglpopmatrix;
  dc.drawer.SetColor(0, 100, 100,255);
  oglsm.myglpushmatrix;
  oglsm.mygltranslated(param.CSIcon.csx.x + 2, -getviewcontrol.clientheight + param.CSIcon.csx.y - 10, 0);
  //textwrite('X');
  oglsm.myglpopmatrix;
  oglsm.myglpushmatrix;
  oglsm.mygltranslated(param.CSIcon.csy.x + 2, -getviewcontrol.clientheight + param.CSIcon.csy.y - 10, 0);
  //textwrite('Y');
  oglsm.myglpopmatrix;
  oglsm.myglpushmatrix;
  oglsm.mygltranslated(param.CSIcon.csz.x + 2, -getviewcontrol.clientheight + param.CSIcon.csz.y - 10, 0);
  //textwrite('Z');
  oglsm.myglpopmatrix;
  oglsm.myglLoadIdentity;
  *)
  //glColor3ub(255, 255, 255);
  dc.drawer.startrender(TRM_WindowSpace,dc.matrixs);
  dc.drawer.SetColor(foreground);
  //oglsm.glColor3ubv(foreground);

  if param.seldesc.MouseFrameON then
  begin
    if param.seldesc.MouseFrameInverse then
    begin
    {oglsm.myglLogicOp(GL_XOR);}
    dc.drawer.SetDrawMode(TDM_XOR);
    dc.drawer.SetPenStyle(TPS_Dash);
    //dc.drawer.SetColor(255,0,0,0);
    {oglsm.myglLineStipple(1, $F0F0);
    oglsm.myglEnable(GL_LINE_STIPPLE);}
    end;
    dc.drawer.DrawLine2DInDCS(param.seldesc.Frame1.x, param.seldesc.Frame1.y,param.seldesc.Frame2.x, param.seldesc.Frame1.y);
    dc.drawer.DrawLine2DInDCS(param.seldesc.Frame2.x, param.seldesc.Frame1.y,param.seldesc.Frame2.x, param.seldesc.Frame2.y);
    dc.drawer.DrawLine2DInDCS(param.seldesc.Frame2.x, param.seldesc.Frame2.y,param.seldesc.Frame1.x, param.seldesc.Frame2.y);
    dc.drawer.DrawLine2DInDCS(param.seldesc.Frame1.x, param.seldesc.Frame2.y,param.seldesc.Frame1.x, param.seldesc.Frame1.y);

    {oglsm.myglbegin(GL_line_loop);
    oglsm.myglVertex2i(param.seldesc.Frame1.x, param.seldesc.Frame1.y);
    oglsm.myglVertex2i(param.seldesc.Frame2.x, param.seldesc.Frame1.y);
    oglsm.myglVertex2i(param.seldesc.Frame2.x, param.seldesc.Frame2.y);
    oglsm.myglVertex2i(param.seldesc.Frame1.x, param.seldesc.Frame2.y);
    oglsm.myglend;}
    if param.seldesc.MouseFrameInverse then
                                           dc.drawer.SetPenStyle(TPS_Solid);
                                          // oglsm.myglDisable(GL_LINE_STIPPLE);

    if param.seldesc.MouseFrameInverse then
    begin
    dc.drawer.SetDrawMode(TDM_XOR);
    {oglsm.myglLogicOp(GL_XOR);}
    dc.drawer.SetPenStyle(TPS_Dash);
    //oglsm.myglLineStipple(1, $F0F0);
    //oglsm.myglEnable(GL_LINE_STIPPLE);
    end;
    if param.seldesc.MouseFrameInverse then
                                           dc.drawer.SetColor(0,40,0,10)
                                       else
                                           dc.drawer.SetColor(0,0,40,10);
    dc.drawer.DrawQuad2DInDCS(param.seldesc.Frame1.x,param.seldesc.Frame1.y,param.seldesc.Frame2.x,param.seldesc.Frame2.y);
    {oglsm.myglbegin(GL_QUADS);
    oglsm.myglVertex2i(param.seldesc.Frame1.x, param.seldesc.Frame1.y);
    oglsm.myglVertex2i(param.seldesc.Frame2.x, param.seldesc.Frame1.y);
    oglsm.myglVertex2i(param.seldesc.Frame2.x, param.seldesc.Frame2.y);
    oglsm.myglVertex2i(param.seldesc.Frame1.x, param.seldesc.Frame2.y);
    oglsm.myglend;}
    if param.seldesc.MouseFrameInverse then
                                           dc.drawer.SetPenStyle(TPS_Solid);
                                           //oglsm.myglDisable(GL_LINE_STIPPLE);
  end;


  if PDWG<>nil then

  if tocommandmcliccount=0 then a:=1
                           else a:=0;
  if sysvar.DWG.DWG_PolarMode<>nil then
  if sysvar.DWG.DWG_PolarMode^ then
  if param.ontrackarray.total <> 0 then
  begin
    dc.drawer.SetDrawMode(TDM_XOR);
    {oglsm.myglLogicOp(GL_XOR);}
    for i := a to param.ontrackarray.total - 1 do
    begin
     dc.drawer.SetColor(255,255, 0,255);
      dc.drawer.DrawLine2DInDCS(param.ontrackarray.otrackarray[i].dispcoord.x,
                 getviewcontrol.clientheight - param.ontrackarray.otrackarray[i].dispcoord.y + marksize,param.ontrackarray.otrackarray[i].dispcoord.x,
                 getviewcontrol.clientheight - param.ontrackarray.otrackarray[i].dispcoord.y - marksize);
     dc.drawer.DrawLine2DInDCS(param.ontrackarray.otrackarray[i].dispcoord.x + marksize,
                 getviewcontrol.clientheight - param.ontrackarray.otrackarray[i].dispcoord.y,param.ontrackarray.otrackarray[i].dispcoord.x - marksize,
                 getviewcontrol.clientheight - param.ontrackarray.otrackarray[i].dispcoord.y);

      dc.drawer.SetPenStyle(TPS_Dot);
      {oglsm.myglLineStipple(1, $3333);
      oglsm.myglEnable(GL_LINE_STIPPLE);}
      //oglsm.myglbegin(GL_LINES);
      dc.drawer.SetColor(80,80, 80,255);
      if param.ontrackarray.otrackarray[i].arraydispaxis.Count <> 0 then
      begin;
      pt:=param.ontrackarray.otrackarray[i].arraydispaxis.PArray;
      for j := 0 to param.ontrackarray.otrackarray[i].arraydispaxis.count - 1 do
        begin
          if pt.trace then
          begin
            //|---2---|
            //|       |
            //1       3
            //|       |
            //|---4---|
            {1}
            i2dresult:=intercept2dmy(CreateVertex2D(0,0),CreateVertex2D(0,getviewcontrol.clientheight),PGDBVertex2D(@param.ontrackarray.otrackarray[i].dispcoord)^,PGDBVertex2D(@pt.dispraycoord)^);
            {2}
            i2d:=intercept2dmy(CreateVertex2D(0,getviewcontrol.clientheight),CreateVertex2D(getviewcontrol.clientwidth,getviewcontrol.clientheight),PGDBVertex2D(@param.ontrackarray.otrackarray[i].dispcoord)^,PGDBVertex2D(@pt.dispraycoord)^);
            if not i2dresult.isintercept then
                                             i2dresult:=i2d;
            if i2d.isintercept then
            if i2d.t2>0 then
            if (i2d.t2>i2dresult.t2)or(i2dresult.t2<0) then
                                            i2dresult:=i2d;
            {3}
            i2d:=intercept2dmy(CreateVertex2D(getviewcontrol.clientwidth,getviewcontrol.clientheight),CreateVertex2D(getviewcontrol.clientwidth,0),PGDBVertex2D(@param.ontrackarray.otrackarray[i].dispcoord)^,PGDBVertex2D(@pt.dispraycoord)^);
            if not i2dresult.isintercept then
                                             i2dresult:=i2d;
            if i2d.isintercept then
            if i2d.t2>0 then
            if (i2d.t2>i2dresult.t2)or(i2dresult.t2<0) then
                                            i2dresult:=i2d;
            {4}
            i2d:=intercept2dmy(CreateVertex2D(getviewcontrol.clientwidth,0),CreateVertex2D(0,0),PGDBVertex2D(@param.ontrackarray.otrackarray[i].dispcoord)^,PGDBVertex2D(@pt.dispraycoord)^);
            if not i2dresult.isintercept then
                                             i2dresult:=i2d;
            if i2d.isintercept then
            if i2d.t2>0 then
            if (i2d.t2>i2dresult.t2)or(i2dresult.t2<0) then
                                            i2dresult:=i2d;

            //geometry.
            dc.drawer.DrawLine2DInDCS(param.ontrackarray.otrackarray[i].dispcoord.x, getviewcontrol.clientheight - param.ontrackarray.otrackarray[i].dispcoord.y,i2dresult.interceptcoord.x, getviewcontrol.clientheight - i2dresult.interceptcoord.y);
            //glvertex2d(pt.dispraycoord.x, clientheight - pt.dispraycoord.y);
          end;
          inc(pt);
        end;
      end;
      //oglsm.myglend;
      //oglsm.mytotalglend;
      //isOpenGLError;
      dc.drawer.SetPenStyle(TPS_Solid);
      //oglsm.myglDisable(GL_LINE_STIPPLE);
    end;
  end;

  showsnap(DC);

 //{$ENDREGION}
 NotUseLCS:=_NotUseLCS;
  //oglsm.myglMatrixMode(GL_PROJECTION);
  //glLoadIdentity;
  //gdb.GetCurrentDWG.pcamera^.projMatrix:=onematrix;
  if PDWG<>nil then
  begin
{    if wa.param.projtype = Projparalel then
  begin
    gdb.GetCurrentDWG.pcamera^.projMatrix:=ortho(-clientwidth * wa.param.zoom / 2, clientwidth * wa.param.zoom / 2,
            -clientheight * wa.param.zoom / 2, clientheight * wa.param.zoom / 2,
             gdb.GetCurrentDWG.pcamera^.zmin, gdb.GetCurrentDWG.pcamera^.zmax,@onematrix);
  end;
  if wa.param.projtype = Projperspective then
    gdb.GetCurrentDWG.pcamera^.projMatrix:=Perspective(gdb.GetCurrentDWG.pcamera^.fovy, Width / Height, gdb.GetCurrentDWG.pcamera^.zmin, gdb.GetCurrentDWG.pcamera^.zmax,@onematrix);
    glLoadMatrixD(@gdb.GetCurrentDWG.pcamera^.projMatrix);
   glulookat(-gdb.GetCurrentDWG.pcamera^.point.x, -gdb.GetCurrentDWG.pcamera^.point.y, -gdb.GetCurrentDWG.pcamera^.point.z,
             -gdb.GetCurrentDWG.pcamera^.point.x + gdb.GetCurrentDWG.pcamera^.look.x,
             -gdb.GetCurrentDWG.pcamera^.point.y + gdb.GetCurrentDWG.pcamera^.look.y,
             -gdb.GetCurrentDWG.pcamera^.point.z + gdb.GetCurrentDWG.pcamera^.look.z,
              gdb.GetCurrentDWG.pcamera^.ydir.x, gdb.GetCurrentDWG.pcamera^.ydir.y, gdb.GetCurrentDWG.pcamera^.ydir.z);
  gltranslated(0, 0, -500);
  oglsm.myglMatrixMode(GL_MODELVIEW);
  glLoadIdentity;
  oglsm.myglDisable(GL_LIGHTING);
}
  dc.drawer.ClearStatesMachine;
  dc.drawer.SetDrawMode(TDM_Normal);
end;
end;
procedure TGeneralViewArea.DrawCSAxis(var DC:TDrawContext);
var
  td,td2,td22:gdbdouble;
begin
  dc.drawer.SetDrawMode(TDM_Normal);
  CalcOptimalMatrix;
  if param.CSIcon.axislen<>0 then {переделать}
  begin
  td:=param.CSIcon.axislen;
  td2:=td/5;
  td22:=td2/3;

  dc.drawer.SetColor(255, 0, 0,255);
  dc.drawer.DrawLine3DInModelSpace(param.CSIcon.CSIconCoord,param.CSIcon.CSIconX,dc.matrixs);
  dc.drawer.DrawLine3DInModelSpace(param.CSIcon.CSIconX,createvertex(param.CSIcon.CSIconCoord.x + td-td2, param.CSIcon.CSIconCoord.y-td22 , param.CSIcon.CSIconCoord.z),dc.matrixs);
  dc.drawer.DrawLine3DInModelSpace(param.CSIcon.CSIconX,createvertex(param.CSIcon.CSIconCoord.x + td-td2, param.CSIcon.CSIconCoord.y+td22 , param.CSIcon.CSIconCoord.z),dc.matrixs);

  dc.drawer.SetColor(0, 255, 0,255);
  dc.drawer.DrawLine3DInModelSpace(param.CSIcon.CSIconCoord,param.CSIcon.CSIconY,dc.matrixs);
  dc.drawer.DrawLine3DInModelSpace(param.CSIcon.CSIconY,createvertex(param.CSIcon.CSIconCoord.x-td22, param.CSIcon.CSIconCoord.y + td-td2, param.CSIcon.CSIconCoord.z),dc.matrixs);
  dc.drawer.DrawLine3DInModelSpace(param.CSIcon.CSIconY,createvertex(param.CSIcon.CSIconCoord.x+td22, param.CSIcon.CSIconCoord.y + td-td2, param.CSIcon.CSIconCoord.z),dc.matrixs);

  dc.drawer.SetColor(0, 0, 255,255);
  dc.drawer.DrawLine3DInModelSpace(param.CSIcon.CSIconCoord,param.CSIcon.CSIconZ,dc.matrixs);

  if IsVectorNul(vectordot(pdwg.GetPcamera.prop.look,ZWCS)) then
  begin
      dc.drawer.SetColor(255, 255, 255,255);
      dc.drawer.DrawLine3DInModelSpace(createvertex(param.CSIcon.CSIconCoord.x + td2, param.CSIcon.CSIconCoord.y , param.CSIcon.CSIconCoord.z),createvertex(param.CSIcon.CSIconCoord.x + td2, param.CSIcon.CSIconCoord.y+ td2 , param.CSIcon.CSIconCoord.z),dc.matrixs);
      dc.drawer.DrawLine3DInModelSpace(createvertex(param.CSIcon.CSIconCoord.x + td2, param.CSIcon.CSIconCoord.y+ td2 , param.CSIcon.CSIconCoord.z),createvertex(param.CSIcon.CSIconCoord.x, param.CSIcon.CSIconCoord.y+ td2 , param.CSIcon.CSIconCoord.z),dc.matrixs);
  end;
  end;
  dc.drawer.ClearStatesMachine;
  dc.drawer.SetDrawMode(TDM_Normal);
end;
procedure TGeneralViewArea.DrawGrid(var DC:TDrawContext);
begin
end;
procedure TGeneralViewArea.LightOn(var DC:TDrawContext);
begin
end;
procedure TGeneralViewArea.LightOff(var DC:TDrawContext);
begin
end;
procedure TGeneralViewArea.SwapBuffers(var DC:TDrawContext);
begin
     drawer.SwapBuffers;
end;
function TGeneralViewArea.treerender;
var
   currtime:TDateTime;
   Hour,Minute,Second,MilliSecond:word;
   q1,q2:gdbboolean;
   //currd:PTDrawing;
begin //currd:=gdb.GetCurrentDWG;
    if (sysvar.RD.RD_MaxRenderTime^<>0) then
    begin
     currtime:=now;
     decodetime(currtime-StartTime,Hour,Minute,Second,MilliSecond);
     if assigned(sysvar.RD.RD_MaxRenderTime) then
     if (sysvar.RD.RD_MaxRenderTime^<>0) then
     if (sysvar.RD.RD_MaxRenderTime^-MilliSecond)<0 then
                            begin
                                  result:=true;
                                  exit;
                            end;
     end;
     q1:=false;
     q2:=false;

  if Node.infrustum={gdb.GetCurrentDWG}PDWG.Getpcamera.POSCOUNT then
  begin
       if (Node.FulDraw)or(Node.nul.count=0) then
       begin
       if assigned(node.pminusnode)then
                                       if node.minusdrawpos<>PDWG.Getpcamera.DRAWCOUNT then
                                       begin
                                       if not treerender(node.pminusnode^,StartTime,dc) then
                                           node.minusdrawpos:=PDWG.Getpcamera.DRAWCOUNT
                                                                                     else
                                                                                         q1:=true;
                                       end;
       if assigned(node.pplusnode)then
                                      if node.plusdrawpos<>PDWG.Getpcamera.DRAWCOUNT then
                                      begin
                                       if not treerender(node.pplusnode^,StartTime,dc) then
                                           node.plusdrawpos:=PDWG.Getpcamera.DRAWCOUNT
                                                                                    else
                                                                                        q2:=true;
                                      end;
       end;
       if node.nuldrawpos<>PDWG.Getpcamera.DRAWCOUNT then
       begin
        Node.nul.DrawWithattrib(dc{gdb.GetCurrentDWG.pcamera.POSCOUNT,subrender});
        node.nuldrawpos:=PDWG.Getpcamera.DRAWCOUNT;
       end;
  end;
  result:=(q1) or (q2);
  //Node.drawpos:=gdb.GetCurrentDWG.pcamera.DRAWCOUNT;

  //root.DrawWithattrib(gdb.GetCurrentDWG.pcamera.POSCOUNT);
end;
procedure TGeneralViewArea.render;
begin
  if dc.subrender = 0 then
  begin
    PDWG.Getpcamera^.obj_zmax:=-nan;
    PDWG.Getpcamera^.obj_zmin:=-1000000;
    PDWG.Getpcamera^.totalobj:=0;
    PDWG.Getpcamera^.infrustum:=0;
    //gdb.pcamera.getfrustum;
    //pva^.calcvisible;
//    if not wa.param.scrollmode then
//                                PVA.renderfeedbac;
    //if not wa.param.scrollmode then 56RenderOsnapstart(pva);
    CalcOptimalMatrix;
    //Clearcparray;
  end;
  //if wa.param.subrender=0 then
  //pva^.DeSelect;
  //if pva^.Count>0 then
  //                       pva^.Count:=pva^.Count;
  root.{ObjArray.}DrawWithattrib({gdb.GetCurrentDWG.pcamera.POSCOUNT,0}dc);
end;
procedure TGeneralViewArea.finishdraw;
  var
    LPTime:Tdatetime;
begin
     //inc(sysvar.debug.int1);
     CalcOptimalMatrix;
     drawer.RestoreBuffers;
     LPTime:=now();
     PDWG.Getpcamera.DRAWNOTEND:=treerender(PDWG.GetCurrentROOT^.ObjArray.ObjTree,lptime,rc);
     drawer.SaveBuffers;
     showcursor(rc);
     SwapBuffers(rc);
end;
procedure TGeneralViewArea.DrawOrInvalidate;
var
   insidepaint:boolean;
begin
     if sysvar.RD.RD_DrawInsidePaintMessage<>nil then
     begin
          case sysvar.RD.RD_DrawInsidePaintMessage^ of
              T3SB_Fale:insidepaint:=false;
              T3SB_True:insidepaint:=true;
              T3SB_Default:insidepaint:=NeedDrawInsidePaintEvent;
          end;
     end
     else
         insidepaint:=NeedDrawInsidePaintEvent;
     if insidepaint then
                        getviewcontrol.Invalidate
                    else
                        draw;
end;

procedure TGeneralViewArea.draw;
var
  scrollmode:GDBBOOlean;
  LPTime:Tdatetime;
  DC:TDrawContext;
  dt:integer;
  tick:cardinal;
  needredraw,needredrawbydrawer:boolean;
  const msec=1;
begin
  if not assigned(pdwg) then exit;
  if (getviewcontrol.clientwidth=0)or(getviewcontrol.clientheight=0) then exit;
  LPTime:=now;
  needredraw:=param.firstdraw{ or true};
  programlog.logoutstr('TOGLWnd.draw',0,LM_Trace);
  {$IFDEF PERFOMANCELOG}log.programlog.LogOutStrFast('TOGLWnd.draw',lp_IncPos);{$ENDIF}

  //-----------------------------------MakeCurrent;{не забыть что обычный контекст не делает себя текущим сам!}


  foreground.r:=not(sysvar.RD.RD_BackGroundColor^.r);
  foreground.g:=not(sysvar.RD.RD_BackGroundColor^.g);
  foreground.b:=not(sysvar.RD.RD_BackGroundColor^.b);
  dc:=CreateRC;
  needredrawbydrawer:=startpaint;
  needredraw:=needredrawbydrawer or needredraw;
  if assigned(SysVar.RD.RD_LineSmooth)then
                                          dc.drawer.SetLineSmooth(SysVar.RD.RD_LineSmooth^);
  dc.drawer.SetZTest(true);
  if PDWG<>nil then
  begin
  {else if sysvar.RD.RD_Restore_Mode^=WND_Texture then}
  begin
  if needredraw then
  begin
    inc(PDWG.Getpcamera^.DRAWCOUNT);
    dc.drawer.ClearStatesMachine;

    dc.drawer.SetClearColor(sysvar.RD.RD_BackGroundColor^.r,sysvar.RD.RD_BackGroundColor^.g,sysvar.RD.RD_BackGroundColor^.b,sysvar.RD.RD_BackGroundColor^.a);
    dc.drawer.ClearScreen(true);

    CalcOptimalMatrix;
    if sysvar.RD.RD_UseStencil<>nil then
    if sysvar.RD.RD_UseStencil^ then
    begin
         dc.drawer.SetFillStencilMode;
         dc.drawer.startrender(TRM_ModelSpace,dc.matrixs);
         PDWG.GetSelObjArray.drawobject(dc);
         dc.drawer.SetDrawWithStencilMode;
    end
       else
           dc.drawer.DisableStencil
       else
           dc.drawer.DisableStencil;
    dc.drawer.SetLineWidth(1);
    dc.drawer.SetPointSize(1);
    dc.drawer.SetPointSmooth(false);

    DrawGrid(dc);

    LightOn(dc);

    if (sysvar.DWG.DWG_SystmGeometryDraw^) then
                                               begin
                                               dc.drawer.setcolor(palette[sysvar.SYS.SYS_SystmGeometryColor^+2].RGB);
                                               PDWG.GetCurrentROOT^.ObjArray.ObjTree.draw(dc);
                                               end;
    begin
    dc.drawer.startrender(TRM_ModelSpace,dc.matrixs);
    PDWG.Getpcamera.DRAWNOTEND:=treerender(PDWG.GetCurrentROOT^.ObjArray.ObjTree,lptime,dc);
    dc.drawer.endrender;
    end;
    PDWG.GetCurrentROOT.DrawBB(dc);

    DrawCSAxis(dc);

    dc.drawer.ClearStatesMachine;


    drawer.SaveBuffers;

    dc.drawer.SetZTest(false);
    inc(dc.subrender);
    if commandmanager.pcommandrunning<>nil then
                                               commandmanager.pcommandrunning^.DrawHeplGeometry;

    scrollmode:=param.scrollmode;
    param.scrollmode:=true;
    render(PDWG.GetConstructObjRoot^,dc);


    param.scrollmode:=scrollmode;
    PDWG.GetConstructObjRoot.DrawBB(dc);


    PDWG.GetSelObjArray.remappoints(PDWG.GetPcamera.POSCOUNT,param.scrollmode,PDWG.GetPcamera^,PDWG^.myGluProject2,dc);
    dc.drawer.DisableStencil;
    dc.MaxDetail:=true;
    PDWG.GetSelObjArray.drawobj(dc);
    dec(dc.subrender);
    LightOff(dc);
    showcursor(dc);
  end
  else
  begin
    LightOff(dc);
    drawer.RestoreBuffers;
    inc(dc.subrender);
    dc.drawer.startrender(TRM_ModelSpace,dc.matrixs);
    if PDWG.GetConstructObjRoot.ObjArray.Count>0 then
                                                    PDWG.GetConstructObjRoot.ObjArray.Count:=PDWG.GetConstructObjRoot.ObjArray.Count;
    if commandmanager.pcommandrunning<>nil then
                                               commandmanager.pcommandrunning^.DrawHeplGeometry;
    scrollmode:=param.scrollmode;
    param.scrollmode:=true;
    render(PDWG.GetConstructObjRoot^,dc);
    param.scrollmode:=scrollmode;
    PDWG.GetConstructObjRoot.DrawBB(dc);

    dc.drawer.DisableStencil;
    dc.MaxDetail:=true;
    PDWG.GetSelObjArray.drawobj(dc);
    dc.drawer.SetLineWidth(1);
    dc.drawer.SetPointSize(1);
    showcursor(dc);
    dc.drawer.startrender(TRM_WindowSpace,dc.matrixs);
    dc.drawer.DrawDebugGeometry;

    dec(dc.subrender);
  end;
  end
  end
     else begin
               dc.drawer.SetClearColor(150,150,150,255);
               dc.drawer.ClearScreen(false);
          end;



  //------------------------------------------------------------------MySwapBuffers(OGLContext);//SwapBuffers(DC);

  //oglsm.mytotalglend;
  dc.drawer.ClearStatesMachine;
  SwapBuffers(dc);
  endpaint;

  lptime:=now()-LPTime;
  tick:=round(lptime*10e7);
  if needredraw then
                    begin
                         if assigned(sysvar.RD.RD_LastRenderTime)then
                         sysvar.RD.RD_LastRenderTime^:=tick*msec
                    end
                else
                    begin
                         if assigned(sysvar.RD.RD_LastUpdateTime)then
                         sysvar.RD.RD_LastUpdateTime^:=tick*msec;
                    end;
  {$IFDEF PERFOMANCELOG}
                       if needredraw then
                                              log.programlog.LogOutStrFast('Draw time='+inttostr(sysvar.RD.RD_LastRenderTime^),0)
                                          else
                                              log.programlog.LogOutStrFast('ReDraw time='+inttostr(sysvar.RD.RD_LastUpdateTime^),0);
  {$ENDIF}
  if needredraw then
  if assigned(SysVar.RD.RD_ImageDegradation.RD_ID_Enabled)then
  if SysVar.RD.RD_ImageDegradation.RD_ID_Enabled^ then
  begin
  dt:=sysvar.RD.RD_LastRenderTime^-SysVar.RD.RD_ImageDegradation.RD_ID_PrefferedRenderTime^;
  if dt<0 then
                                         SysVar.RD.RD_ImageDegradation.RD_ID_CurrentDegradationFactor:=SysVar.RD.RD_ImageDegradation.RD_ID_CurrentDegradationFactor+{0.5}dt/5
                                     else
                                         SysVar.RD.RD_ImageDegradation.RD_ID_CurrentDegradationFactor:=SysVar.RD.RD_ImageDegradation.RD_ID_CurrentDegradationFactor+{0.5}dt/10;
  if SysVar.RD.RD_ImageDegradation.RD_ID_CurrentDegradationFactor>SysVar.RD.RD_ImageDegradation.RD_ID_MaxDegradationFactor^ then
                                                 SysVar.RD.RD_ImageDegradation.RD_ID_CurrentDegradationFactor:=SysVar.RD.RD_ImageDegradation.RD_ID_MaxDegradationFactor^;
  if SysVar.RD.RD_ImageDegradation.RD_ID_CurrentDegradationFactor<0 then
                                                 SysVar.RD.RD_ImageDegradation.RD_ID_CurrentDegradationFactor:=0;
  end;
  param.firstdraw := false;
  {$IFDEF PERFOMANCELOG}log.programlog.LogOutStrFast('TOGLWnd.draw---{end}',lp_DecPos);{$ENDIF}
end;
procedure TGeneralViewArea.showsnap(var DC:TDrawContext);
begin
  if param.ospoint.ostype <> os_none then
  begin
    dc.drawer.SetColor(255,255, 0,255);
    dc.drawer.SetLineWidth(2);
    dc.drawer.TranslateCoord2D(param.ospoint.dispcoord.x, getviewcontrol.clientheight - param.ospoint.dispcoord.y);
    dc.drawer.ScaleCoord2D(sysvar.DISP.DISP_OSSize^,sysvar.DISP.DISP_OSSize^);
      if (param.ospoint.ostype = os_begin)or(param.ospoint.ostype = os_end) then
      begin
           dc.drawer.DrawClosedPolyLine2DInDCS([-1,  1,
                                                 1,  1,
                                                 1, -1,
                                                -1, -1]);
      end
      else
      if (param.ospoint.ostype = os_midle) then
      begin
           dc.drawer.DrawClosedPolyLine2DInDCS([ 0,              -1,
                                                 0.8660254037844, 0.5,
                                                -0.8660254037844, 0.5]);
      end
      else
      if (param.ospoint.ostype = os_1_4)or(param.ospoint.ostype = os_3_4) then
      begin
           dc.drawer.DrawLine2DInDCS(-0.5,  1,-0.5, -1);
           dc.drawer.DrawLine2DInDCS(-0.2, -1, 0.15, 1);
           dc.drawer.DrawLine2DInDCS( 0.5, -1, 0.15, 1);
      end
      else
      if (param.ospoint.ostype = os_center)then
                                               begin
                                                 dc.drawer.DrawClosedPolyLine2DInDCS([-1,     0,
                                                                                      -0.707, 0.707,
                                                                                       0,     1,
                                                                                       0.707, 0.707,
                                                                                       1,     0,
                                                                                       0.707,-0.707,
                                                                                       0,    -1,
                                                                                      -0.707,-0.707
                                                                                       ]);
                                               end
      else
      if (param.ospoint.ostype = os_q0)or(param.ospoint.ostype = os_q1)
       or(param.ospoint.ostype = os_q2)or(param.ospoint.ostype = os_q3) then
      begin
           dc.drawer.DrawClosedPolyLine2DInDCS([-1,  0,
                                                 0,  1,
                                                 1,  0,
                                                 0, -1,
                                                -1,  0]);
      end
      else
      if (param.ospoint.ostype = os_1_3)or(param.ospoint.ostype = os_2_3) then
      begin
                                      dc.drawer.DrawLine2DInDCS(-0.5, 1,-0.5, -1);
                                      dc.drawer.DrawLine2DInDCS(0, 1,0, -1);
                                      dc.drawer.DrawLine2DInDCS(0.5, 1,0.5, -1);
      end
      else
      if (param.ospoint.ostype = os_point) then
      begin
           dc.drawer.DrawLine2DInDCS(-1, 1,1, -1);
           dc.drawer.DrawLine2DInDCS(-1, -1,1, 1);
      end
      else
      if (param.ospoint.ostype = os_intersection) then
      begin
           dc.drawer.DrawLine2DInDCS(-1, 1,1, -1);
           dc.drawer.DrawLine2DInDCS(-1, -1,1, 1);
      end
      else
      if (param.ospoint.ostype = os_apparentintersection) then
      begin
           dc.drawer.DrawLine2DInDCS(-1, 1,1, -1);
           dc.drawer.DrawLine2DInDCS(-1, -1,1, 1);
           dc.drawer.DrawClosedPolyLine2DInDCS([-1,  1,
                                                 1,  1,
                                                 1, -1,
                                                -1, -1]);
      end
      else
      if (param.ospoint.ostype = os_textinsert) then
      begin
           dc.drawer.DrawLine2DInDCS(-1, 0, 1, 0);
           dc.drawer.DrawLine2DInDCS( 0, 1, 0,-1);
      end
      else
      if (param.ospoint.ostype = os_perpendicular) then
      begin
           dc.drawer.DrawLine2DInDCS(-1,-1,-1, 1);
           dc.drawer.DrawLine2DInDCS(-1, 1, 1, 1);
           dc.drawer.DrawLine2DInDCS(-1, 0, 0, 0);
           dc.drawer.DrawLine2DInDCS( 0, 0, 0, 1);
      end
      else
      if (param.ospoint.ostype = os_trace) then
      begin
           dc.drawer.DrawLine2DInDCS(-1, -0.5,1, -0.5);
           dc.drawer.DrawLine2DInDCS(-1,  0.5,1,  0.5);
      end
      else if (param.ospoint.ostype = os_nearest) then
      begin
           dc.drawer.DrawClosedPolyLine2DInDCS([-1, 1,
                                                 1, 1,
                                                -1,-1,
                                                 1,-1]);
      end;
    dc.drawer.SetLineWidth(1);
  end;
end;

Procedure TGeneralViewArea.Paint;
begin
     WorkArea.Repaint;
end;
procedure TGeneralViewArea.showmousecursor;
begin
     if assigned(WorkArea) then
     WorkArea.Cursor:=crDefault;
end;
procedure TGeneralViewArea.hidemousecursor;
begin
     if assigned(WorkArea) then
     RemoveCursorIfNeed(WorkArea,sysvar.RD.RD_RemoveSystemCursorFromWorkArea^);
end;
procedure TGeneralViewArea.RestoreMouse;
var
  fv1: GDBVertex;
  DC:TDrawContext;
begin
  CalcOptimalMatrix;
  mouseunproject(param.md.mouse.x, getviewcontrol.clientheight-param.md.mouse.y);
  reprojectaxis;
  if param.seldesc.MouseFrameON then
  begin
    pdwg^.myGluProject2(param.seldesc.Frame13d,
               fv1);
    param.seldesc.Frame1.x := round(fv1.x);
    param.seldesc.Frame1.y := getviewcontrol.clientheight - round(fv1.y);
    if param.seldesc.Frame1.x < 0 then param.seldesc.Frame1.x := 0
    else if param.seldesc.Frame1.x > (getviewcontrol.clientwidth - 1) then param.seldesc.Frame1.x := getviewcontrol.clientwidth - 1;
    if param.seldesc.Frame1.y < 0 then param.seldesc.Frame1.y := 1
    else if param.seldesc.Frame1.y > (getviewcontrol.clientheight - 1) then param.seldesc.Frame1.y := getviewcontrol.clientheight - 1;
  end;

  //param.zoommode := true;
  //param.scrollmode:=true;
  pdwg.GetCurrentROOT.CalcVisibleByTree(pdwg.getpcamera^.frustum,pdwg.getpcamera.POSCOUNT,pdwg.getpcamera.VISCOUNT,pdwg.GetCurrentROOT.ObjArray.ObjTree,pdwg.getpcamera.totalobj,pdwg.getpcamera.infrustum,pdwg.myGluProject2,pdwg.getpcamera.prop.zoom);
  //gdb.GetCurrentROOT.calcvisible(gdb.GetCurrentDWG.pcamera^.frustum,gdb.GetCurrentDWG.pcamera.POSCOUNT,gdb.GetCurrentDWG.pcamera.VISCOUNT);
  pdwg.GetCurrentROOT.calcvisible(pdwg.getpcamera^.frustum,pdwg.getpcamera.POSCOUNT,pdwg.getpcamera.VISCOUNT,pdwg.getpcamera.totalobj,pdwg.getpcamera.infrustum,pdwg.myGluProject2,pdwg.getpcamera.prop.zoom);
  DC:=self.CreateRC;
  pdwg.GetSelObjArray.RenderFeedBack(pdwg^.GetPcamera^.POSCOUNT,pdwg^.GetPcamera^,pdwg^.myGluProject2,dc);

  calcmousefrustum;

  if param.lastonmouseobject<>nil then
                                      begin
                                           PGDBObjEntity(param.lastonmouseobject)^.RenderFeedBack(pdwg.GetPcamera^.POSCOUNT,pdwg^.GetPcamera^, pdwg^.myGluProject2,dc);
                                      end;

  Set3dmouse;
  calcgrid;

  {paint;}

  WaMouseMove(self,[],param.md.mouse.x,param.md.mouse.y);

end;

procedure TGeneralViewArea.RotTo(x0,y0,z0:GDBVertex);
const
     steps=10;
var
  fv1: GDBVertex;
  i:integer;
  pucommand:pointer;
  q1,q2,q:GDBQuaternion;
  pcam:PGDBBaseCamera;

  mat1,mat2,mat : DMatrix4D;
begin
  pcam:=PDWG.Getpcamera;
  mat1:=CreateMatrixFromBasis(pcam.prop.xdir,pcam.prop.ydir,pcam.prop.look);
  mat2:=CreateMatrixFromBasis(x0,y0,z0);

  q1:=QuaternionFromMatrix(mat1);
  q2:=QuaternionFromMatrix(mat2);
  pucommand:=PDWG^.StoreOldCamerapPos;
  for i:=1 to steps do
  begin
  q:=QuaternionSlerp(q1,q2,i/steps);
  mat:=QuaternionToMatrix(q);
  CreateBasisFromMatrix(mat,pcam.prop.xdir,pcam.prop.ydir,pcam.prop.look);

  //wa.PDWG.Getpcamera^.prop.point:=vertexadd(camerapos,geometry.VertexMulOnSc(target,i/steps));
  //wa.PDWG.Getpcamera^.prop.zoom:=wa.PDWG.Getpcamera^.prop.zoom+tzoom{*i}/steps;
  param.firstdraw := true;
  PDWG.Getpcamera^.NextPosition;
  //RestoreMouse;
  {}CalcOptimalMatrix;
  mouseunproject(param.md.mouse.x,param.md.mouse.y);
  reprojectaxis;
  PDWG.GetCurrentROOT.CalcVisibleByTree(PDWG.Getpcamera^.frustum,PDWG.Getpcamera.POSCOUNT,PDWG.Getpcamera.VISCOUNT,PDWG.GetCurrentRoot.ObjArray.ObjTree,pdwg.getpcamera.totalobj,pdwg.getpcamera.infrustum,pdwg.myGluProject2,pdwg.getpcamera.prop.zoom);
  PDWG.GetConstructObjRoot.calcvisible(PDWG.Getpcamera^.frustum,PDWG.Getpcamera.POSCOUNT,PDWG.Getpcamera.VISCOUNT,pdwg.getpcamera.totalobj,pdwg.getpcamera.infrustum,pdwg.myGluProject2,pdwg.getpcamera.prop.zoom);
  WaMouseMove(nil,[],param.md.mouse.x,param.md.mouse.y);
  if i=steps then
    begin
  if param.seldesc.MouseFrameON then
  begin
    pdwg.myGluProject2(param.seldesc.Frame13d,
               fv1);
    param.seldesc.Frame1.x := round(fv1.x);
    param.seldesc.Frame1.y := getviewcontrol.clientheight - round(fv1.y);
    if param.seldesc.Frame1.x < 0 then param.seldesc.Frame1.x := 0
    else if param.seldesc.Frame1.x > (getviewcontrol.clientwidth - 1) then param.seldesc.Frame1.x := getviewcontrol.clientwidth - 1;
    if param.seldesc.Frame1.y < 0 then param.seldesc.Frame1.y := 1
    else if param.seldesc.Frame1.y > (getviewcontrol.clientheight - 1) then param.seldesc.Frame1.y := getviewcontrol.clientheight - 1;
  end;
  end;{}
  //----ComitFromObj;

  if sysvar.RD.RD_LastRenderTime^<30 then
                                        sleep(30-sysvar.RD.RD_LastRenderTime^);
  end;
  pcam.prop.xdir:=x0;
  pcam.prop.ydir:=y0;
  pcam.prop.look:=z0;
  PDWG^.StoreNewCamerapPos(pucommand);
  calcgrid;

  draw;

end;
procedure TGeneralViewArea.ZoomSel;
var
   psa:PGDBSelectedObjArray;
begin
     psa:=PDWG^.GetSelObjArray;
     if psa<>nil then
     begin
          if psa^.Count=0 then
                              begin
                                   historyout('ZoomSel: Ничего не выбрано?');
                                   exit;
                              end;
          zoomtovolume(psa^.getonlyoutbound);
     end;

end;
procedure TGeneralViewArea.ZoomAll;
var
  proot:PGDBObjGenericSubEntry;
begin
  proot:=pdwg.GetCurrentROOT;
  if proot<>nil then
                    zoomtovolume(proot.vp.BoundingBox);
end;

procedure TGeneralViewArea.ZoomToVolume(Volume:TBoundingBox);
  const
       steps=10;
  var
    tpz,tzoom: GDBDouble;
    {fv1,tp,}wcsLBN,wcsRTF,dcsLBN,dcsRTF: GDBVertex;
    camerapos,target:GDBVertex;
    i:integer;
    pucommand:pointer;
  begin
    if param.projtype = PROJPerspective then
                                            begin
                                                 historyout('Zoom: Works only for parallel projection!');
                                            end;
    historyout('Zoom: Works only for top view!');


    CalcOptimalMatrix;

    dcsLBN:=InfinityVertex;
    dcsRTF:=MinusInfinityVertex;
    wcsLBN:=InfinityVertex;
    wcsRTF:=MinusInfinityVertex;
    {tp:=}ProjectPoint(Volume.LBN.x,Volume.LBN.y,Volume.LBN.Z,wcsLBN,wcsRTF,dcsLBN,dcsRTF);
    {tp:=}ProjectPoint(Volume.RTF.x,Volume.LBN.y,Volume.LBN.Z,wcsLBN,wcsRTF,dcsLBN,dcsRTF);
    {tp:=}ProjectPoint(Volume.RTF.x,Volume.RTF.y,Volume.LBN.Z,wcsLBN,wcsRTF,dcsLBN,dcsRTF);
    {tp:=}ProjectPoint(Volume.LBN.x,Volume.RTF.y,Volume.LBN.Z,wcsLBN,wcsRTF,dcsLBN,dcsRTF);
    {tp:=}ProjectPoint(Volume.LBN.x,Volume.LBN.y,Volume.RTF.Z,wcsLBN,wcsRTF,dcsLBN,dcsRTF);
    {tp:=}ProjectPoint(Volume.RTF.x,Volume.LBN.y,Volume.RTF.Z,wcsLBN,wcsRTF,dcsLBN,dcsRTF);
    {tp:=}ProjectPoint(Volume.RTF.x,Volume.RTF.y,Volume.RTF.Z,wcsLBN,wcsRTF,dcsLBN,dcsRTF);
    {tp:=}ProjectPoint(Volume.LBN.x,Volume.RTF.y,Volume.RTF.Z,wcsLBN,wcsRTF,dcsLBN,dcsRTF);

    dcsLBN.z:=0;
    dcsRTF.z:=0;
    pdwg.myGluUnProject(dcsLBN,wcsLBN);
    pdwg.myGluUnProject(dcsRTF,wcsRTF);

       if wcsRTF.x<wcsLBN.x then
                                begin
                                     tpz:=wcsLBN.x;
                                     wcsLBN.x:=wcsRTF.x;
                                     wcsRTF.x:=tpz;
                                end;
       if wcsRTF.y<wcsLBN.y then
                                begin
                                tpz:=wcsLBN.y;
                                wcsLBN.y:=wcsRTF.y;
                                wcsRTF.y:=tpz;
                                end;
       if wcsRTF.z<wcsLBN.z then
                                begin
                                tpz:=wcsLBN.z;
                                wcsLBN.z:=wcsRTF.z;
                                wcsRTF.z:=tpz;
                                end;
    if (abs(wcsRTF.x-wcsLBN.x)<eps)and(abs(wcsRTF.y-wcsLBN.y)<eps) then
                                                                      begin
                                                                           historyout('ZoomToVolume: Пустой чертеж?');
                                                                           exit;
                                                                      end;
    target:=createvertex(-(wcsLBN.x+(wcsRTF.x-wcsLBN.x)/2),-(wcsLBN.y+(wcsRTF.y-wcsLBN.y)/2),-(wcsLBN.z+(wcsRTF.z-wcsLBN.z)/2));
    camerapos:=pdwg.Getpcamera^.prop.point;
    target:=vertexsub(target,camerapos);

    tzoom:=abs((wcsRTF.x-wcsLBN.x){*wa.pdwg.GetPcamera.prop.xdir.x}/getviewcontrol.clientwidth);
    tpz:=abs((wcsRTF.y-wcsLBN.y){*wa.pdwg.GetPcamera.prop.ydir.y}/getviewcontrol.clientheight);

    //-------with gdb.GetCurrentDWG.UndoStack.PushCreateTGChangeCommand(gdb.GetCurrentDWG.pcamera^.prop)^ do
    pucommand:=PDWG^.StoreOldCamerapPos;
    begin

    if tpz>tzoom then tzoom:=tpz;

    tzoom:=tzoom-PDWG.Getpcamera^.prop.zoom;

    for i:=1 to steps do
    begin
    SetCameraPosZoom(vertexadd(camerapos,geometry.VertexMulOnSc(target,i/steps)),PDWG.Getpcamera^.prop.zoom+tzoom{*i}/steps,i=steps);
    if assigned(sysvar.RD.RD_LastRenderTime)then
    if sysvar.RD.RD_LastRenderTime^<30 then
                                          sleep(30-sysvar.RD.RD_LastRenderTime^);
    end;
    PDWG^.StoreNewCamerapPos(pucommand);
    calcgrid;

    draw;
    doCameraChanged;
    end;
  end;
procedure TGeneralViewArea.DISP_ZoomFactor;
var
  glx1, gly1: GDBDouble;
  pucommand:pointer;
//  fv1: GDBVertex;
begin
  {$IFDEF PERFOMANCELOG}log.programlog.LogOutStrFast('TOGLWnd.DISP_ZoomFactor',lp_incPos);{$ENDIF}
  //gdb.GetCurrentDWG.UndoStack.PushChangeCommand(@gdb.GetCurrentDWG.pcamera^.prop,sizeof(GDBCameraBaseProp));
  //with gdb.GetCurrentDWG.UndoStack.PushCreateTGChangeCommand(gdb.GetCurrentDWG.pcamera^.prop)^ do
  pucommand:=PDWG^.StoreOldCamerapPos;
  begin
        CalcOptimalMatrix;
        if not param.md.mousein then
                                    mouseunproject(getviewcontrol.clientwidth div 2, getviewcontrol.clientheight div 2);
        glx1 := param.md.mouseray.lbegin.x;
        gly1 := param.md.mouseray.lbegin.y;
        if param.projtype = ProjParalel then
          PDWG.Getpcamera^.prop.zoom := PDWG.Getpcamera^.prop.zoom * x
        else
        begin
          PDWG.Getpcamera^.prop.point.x := PDWG.Getpcamera^.prop.point.x + (PDWG.Getpcamera^.prop.look.x *
          (PDWG.Getpcamera^.zmax - PDWG.Getpcamera^.zmin) * sign(x - 1) / 10);
          PDWG.Getpcamera^.prop.point.y := PDWG.Getpcamera^.prop.point.y + (PDWG.Getpcamera^.prop.look.y *
          (PDWG.Getpcamera^.zmax - PDWG.Getpcamera^.zmin) * sign(x - 1) / 10);
          PDWG.Getpcamera^.prop.point.z := PDWG.Getpcamera^.prop.point.z + (PDWG.Getpcamera^.prop.look.z *
          (PDWG.Getpcamera^.zmax - PDWG.Getpcamera^.zmin) * sign(x - 1) / 10);
        end;

        CalcOptimalMatrix;
        if param.md.mousein then
                                mouseunproject(param.md.mouse.x, getviewcontrol.clientheight-param.md.mouse.y)
                            else
                                mouseunproject(getviewcontrol.clientwidth div 2, getviewcontrol.clientheight div 2);
        if param.projtype = ProjParalel then
        begin
        PDWG.Getpcamera^.prop.point.x := PDWG.Getpcamera^.prop.point.x - (glx1 - param.md.mouseray.lbegin.x);
        PDWG.Getpcamera^.prop.point.y := PDWG.Getpcamera^.prop.point.y - (gly1 - param.md.mouseray.lbegin.y);
        end;
        PDWG^.StoreNewCamerapPos(pucommand);
        //ComitFromObj;
  end;
  doCameraChanged;
  {$IFDEF PERFOMANCELOG}log.programlog.LogOutStrFast('TOGLWnd.DISP_ZoomFactor----{end}',lp_decPos);{$ENDIF}
end;

procedure TGeneralViewArea.SetCameraPosZoom(_pos:gdbvertex;_zoom:gdbdouble;finalcalk:gdbboolean);
var
  fv1: GDBVertex;
begin
    PDWG.Getpcamera^.prop.point:=_pos;
    PDWG.Getpcamera^.prop.zoom:=_zoom;
    param.firstdraw := true;
    PDWG.Getpcamera^.NextPosition;

    CalcOptimalMatrix;
    mouseunproject(param.md.mouse.x,param.md.mouse.y);
    reprojectaxis;
    PDWG.GetCurrentROOT.CalcVisibleByTree(PDWG.Getpcamera^.frustum,PDWG.Getpcamera.POSCOUNT,PDWG.Getpcamera.VISCOUNT,PDWG.GetCurrentRoot.ObjArray.ObjTree,pdwg.getpcamera.totalobj,pdwg.getpcamera.infrustum,pdwg.myGluProject2,pdwg.getpcamera.prop.zoom);
    PDWG.GetConstructObjRoot.calcvisible(PDWG.Getpcamera^.frustum,PDWG.Getpcamera.POSCOUNT,PDWG.Getpcamera.VISCOUNT,pdwg.getpcamera.totalobj,pdwg.getpcamera.infrustum,pdwg.myGluProject2,pdwg.getpcamera.prop.zoom);

  if finalcalk then
    begin
  if param.seldesc.MouseFrameON then
  begin
    pdwg.myGluProject2(param.seldesc.Frame13d,
               fv1);
    param.seldesc.Frame1.x := round(fv1.x);
    param.seldesc.Frame1.y := getviewcontrol.clientheight - round(fv1.y);
    if param.seldesc.Frame1.x < 0 then param.seldesc.Frame1.x := 0
    else if param.seldesc.Frame1.x > (getviewcontrol.clientwidth - 1) then param.seldesc.Frame1.x := getviewcontrol.clientwidth - 1;
    if param.seldesc.Frame1.y < 0 then param.seldesc.Frame1.y := 1
    else if param.seldesc.Frame1.y > (getviewcontrol.clientheight - 1) then param.seldesc.Frame1.y := getviewcontrol.clientheight - 1;
  end;
  end;
  WaMouseMove(nil,[],param.md.mouse.x,param.md.mouse.y);
end;

procedure TGeneralViewArea.Set3dmouse;
begin
    if (param.ospoint.ostype <> os_none)or(currentmousemovesnaptogrid)
    then
    begin
         param.md.mouse3dcoord:=param.ospoint.worldcoord;
    end
    else
    begin
        if param.md.mouseonworkplan
        then
            begin
                 param.md.mouse3dcoord:=param.md.mouseonworkplanecoord;
            end
        else
            begin
                 param.md.mouse3dcoord:=param.md.mouseray.lbegin;
            end;
       end;
end;

procedure TGeneralViewArea.doCameraChanged;
begin
     if assigned(onCameraChanged) then onCameraChanged;
end;
function TGeneralViewArea.startpaint;
begin
     result:=drawer.startpaint(InsidePaintMessage>0,getviewcontrol.clientwidth,getviewcontrol.clientheight);
end;
procedure TGeneralViewArea.endpaint;
begin
     drawer.endpaint(InsidePaintMessage>0);
end;
procedure TGeneralViewArea.WaMouseEnter;
begin
     param.md.mousein:=true;
     //DrawOrInvalidate
end;
procedure TGeneralViewArea.WaMouseLeave;
begin
     param.md.mousein:=false;
     DrawOrInvalidate;
end;
procedure TGeneralViewArea.WaResize(sender:tobject);
var
   rect:trect;
begin
     rect:=getviewcontrol.ClientRect;
     drawer.WorkAreaResize(rect);
     getviewcontrol.invalidate;
     param.height := rect.bottom;
     param.width := rect.right;
end;
procedure TGeneralViewArea.WaMouseWheel(Sender:TObject;Shift: TShiftState; WheelDelta: Integer;MousePos: TPoint;var handled:boolean);
//procedure TOGLWnd.Pre_MouseWheel;
var
//  mpoint: tpoint;
  smallwheel:gdbdouble;
//    glx1, gly1: GDBDouble;
  //fv1: GDBVertex;

//  msg : TMsg;

begin
  {$IFDEF PERFOMANCELOG}log.programlog.LogOutStrFast('TOGLWnd.DoMouseWheel',lp_incPos);{$ENDIF}
  smallwheel:=1+(sysvar.DISP.DISP_ZoomFactor^-1)/10;
  //mpoint := point(mousepos.x - clientorigin.X, mousepos.y - clientorigin.y);
  if {mousein(mpoint)}true then
  begin
    //mpoint := point({mpoint.x - left}0, {mpoint.y - top}0);
    if wheeldelta < 0 then
    begin
      if (ssShift in Shift) then
        DISP_ZoomFactor({1.01}smallwheel)
      else
      begin
        ClearOntrackpoint;
        Create0axis;
        DISP_ZoomFactor(sysvar.DISP.DISP_ZoomFactor^);
      end;
      //handled := true;
    end
    else
    begin
      if (ssShift in Shift) then
        DISP_ZoomFactor({0.990099009901}1/smallwheel)
      else
      begin
        ClearOntrackpoint;
        DISP_ZoomFactor(1 / sysvar.DISP.DISP_ZoomFactor^);
      end;
      //handled := true;
    end;
  end;
  //pre_mousemove(0,param.md.mouse.x,param.md.mouse.y,r);
      //param.firstdraw := true;
      //CalcOptimalMatrix;
      //gdb.GetCurrentDWG.ObjRoot.calcvisible;
      //gdb.GetCurrentDWG.ConstructObjRoot.calcvisible;
      //reprojectaxis;
      //draw;
      pdwg.getpcamera^.NextPosition;
      param.firstdraw:=true;
  restoremouse;
  paint;

  {if (PeekMessage(msg,handle,WM_MOUSEWHEEL,0,PM_NOREMOVE)) then
                                                                           param.scrollmode:=true
                                                                       else
                                                                           begin
                                                                           param.scrollmode:=false;
                                                                           paint;
                                                                           end;}

  inherited;
  handled:=true;
  WaMouseMove(self,[],param.md.mouse.x,param.md.mouse.y);
  {$IFDEF PERFOMANCELOG}log.programlog.LogOutStrFast('TOGLWnd.DoMouseWheel----{end}',lp_decPos);{$ENDIF}
end;

procedure TGeneralViewArea.WaMouseMove(sender:tobject;Shift: TShiftState; X, Y: Integer);
var
  glmcoord1: gdbpiece;
  ux,uy:GDBDouble;
  htext,htext2:gdbstring;
  key: GDBByte;
  f:TzeUnitsFormat;
begin
  {$IFDEF PERFOMANCELOG}log.programlog.LogOutStrFast('TOGLWnd.Pre_MouseMove',lp_IncPos);{$ENDIF}
  if assigned(mainmousemove)then
                                mainmousemove;
  KillOHintTimer(self);
  SetOHintTimer(self);
  currentmousemovesnaptogrid:=false;
  key:=0;
  if (ssShift in Shift) then
                            key := key or MZW_SHIFT;
  if (ssCtrl in Shift) then
                                    key := key or MZW_CONTROL;
  if pdwg=nil then
                            begin
                                   param.md.mouse.y := y;
                                   param.md.mouse.x := x;
                                   param.md.glmouse.y := getviewcontrol.clientheight-y;
                                   param.md.glmouse.x := x;
                                   exit;
                            end;
  glmcoord1:= param.md.mouseraywithoutos;
  //if param.ospoint.ostype<>os_none then
  //                                   glmcoord1.lend := param.ospoint.worldcoord;  //пан при привязке ездит меньше

  if ((param.md.mode) and ((MRotateCamera) or (MMoveCamera)) <> 0) then
    if ((ssCtrl in shift) and ((ssMiddle in shift))) and ((param.md.mode) and (MRotateCamera) <> 0) then
    begin
      uy :=(x - param.md.mouse.x) / 1000;
      ux :=- (y - param.md.mouse.y) / 1000;
      pdwg.RotateCameraInLocalCSXY(ux,uy);
      {with gdb.GetCurrentDWG.UndoStack.CreateTGChangeCommand(gdb.GetCurrentDWG.pcamera^.prop)^ do
      begin
      gdb.GetCurrentDWG.pcamera.RotateInLocalCSXY(ux,uy);
      ComitFromObj;
      end;}
      param.firstdraw := true;
      pdwg.GetPcamera^.NextPosition;
      CalcOptimalMatrix;
      calcgrid;
      //-------------------CalcOptimalMatrix;

      pdwg.GetCurrentROOT.CalcVisibleByTree(pdwg.Getpcamera^.frustum,pdwg.Getpcamera.POSCOUNT,pdwg.Getpcamera.VISCOUNT,pdwg.GetCurrentROOT.ObjArray.ObjTree,pdwg.getpcamera.totalobj,pdwg.getpcamera.infrustum,pdwg.myGluProject2,pdwg.getpcamera.prop.zoom);
      //gdb.GetCurrentROOT.calcalcvisible(gdb.GetCurrentDWG.pcamera^.frustum,gdb.GetCurrentDWG.pcamera.POSCOUNT);
      pdwg.GetConstructObjRoot.calcvisible(pdwg.Getpcamera^.frustum,pdwg.Getpcamera.POSCOUNT,pdwg.Getpcamera.VISCOUNT,pdwg.getpcamera.totalobj,pdwg.getpcamera.infrustum,pdwg.myGluProject2,pdwg.getpcamera.prop.zoom);
      doCameraChanged;
    end
    else
      if ssMiddle in shift then     {MK_Control}
begin
      PanScreen(param.md.mouse.x,param.md.mouse.y,X,Y{,glmcoord1});
      doCameraChanged;
end;

  param.md.mouse.y := y;
  param.md.mouse.x := x;
  param.md.glmouse.y := getviewcontrol.clientheight-y;
  param.md.glmouse.x := x;

  param.md.mouseglue := param.md.mouse;
  param.gluetocp := false;

  if (param.md.mode and MGetControlpoint) <> 0 then
  begin
    param.nearesttcontrolpoint:=pdwg.GetSelObjArray.getnearesttomouse(param.md.mouse.x,param.height-param.md.mouse.y);
    if (param.nearesttcontrolpoint.pcontrolpoint = nil) or (param.nearesttcontrolpoint.disttomouse > 2 * sysvar.DISP.DISP_CursorSize^) then
    begin
      param.md.mouseglue := param.md.mouse;
      param.gluetocp := false;
    end
    else begin
      param.gluetocp := true;
      param.md.mouseglue := param.nearesttcontrolpoint.pcontrolpoint^.dispcoord;
      param.md.mouseglue.y:=getviewcontrol.clientheight-param.md.mouseglue.y;
    end;
  end
  else param.md.mouseglue := param.md.mouse;

  //wa.param.md.mouse:=wa.param.md.mouseglue;
  param.md.glmouse.x := param.md.mouseglue.x;
  param.md.glmouse.y := getviewcontrol.clientheight-param.md.mouseglue.y;

  CalcOptimalMatrix;
  mouseunproject(param.md.glmouse.X, param.md.glmouse.Y);
  CalcMouseFrustum;




  //gdb.GetCurrentDWG.pcamera^.getfrustum();   tyui
  //param.mousefrustum:=gdb.GetCurrentDWG.pcamera^.frustum;

{  for I := 0 to 5 do
    //if param.mousefrustum[0][i]<0 then
                                      begin
                                           param.mousefrustum[i][0]:=-param.mousefrustum[i][0];
                                           param.mousefrustum[i][1]:=-param.mousefrustum[i][1];
                                           param.mousefrustum[i][2]:=-param.mousefrustum[i][2];
                                           param.mousefrustum[i][3]:=-param.mousefrustum[i][3];

                                           param.mousefrustum[i][0]:=param.mousefrustum[i][0]*0.5;
                                           param.mousefrustum[i][1]:=param.mousefrustum[i][1]*0.5;
                                           param.mousefrustum[i][2]:=param.mousefrustum[i][2]*0.5;
                                           param.mousefrustum[i][3]:=param.mousefrustum[i][3]*0.99;
                                      end;

 }
  {param.mousefrustum[0][3]:=-param.mousefrustum[0][3];
  param.mousefrustum[0][0]:=-param.mousefrustum[0][0];

  param.mousefrustum[1][3]:=-param.mousefrustum[1][3];
  param.mousefrustum[1][0]:=-param.mousefrustum[1][0];}

  {param.mousefrustum[1][3]:=-param.mousefrustum[1][3];
  param.mousefrustum[1][0]:=-param.mousefrustum[1][0];}

  {
  param.mousefrustum[1][3]:=-param.mousefrustum[1][3];
  param.mousefrustum[2][3]:=-param.mousefrustum[2][3];
  param.mousefrustum[3][3]:=-param.mousefrustum[3][3];}








  if (param.md.mode and MGetSelectObject) <> 0 then
                                                     getonmouseobjectbytree(PDWG.GetCurrentROOT.ObjArray.ObjTree);
  if (param.md.mode and MGet3DPointWoOP) <> 0 then param.ospoint.ostype := os_none;
  if (param.md.mode and MGet3DPoint) <> 0 then
  begin

      if (param.md.mode and MGetSelectObject) = 0 then
                                                      getonmouseobjectbytree(pdwg.GetCurrentROOT.ObjArray.ObjTree);
      getosnappoint({@gdb.GetCurrentROOT.ObjArray,} 0);
      //create0axis;-------------------------------
    if sysvar.dwg.DWG_OSMode^ <> 0 then
    begin
      if otracktimer = 1 then
      begin
        otracktimer := 0;
        projectaxis;
        project0axis;//-------------------------------
        AddOntrackpoint;
      end;
      if (param.ospoint.ostype <> os_none)and(param.ospoint.ostype <> os_snap)and(param.ospoint.ostype <> os_nearest)and(param.ospoint.ostype<>os_perpendicular) then
      begin
        SetOTrackTimer(@self);
        copyospoint(param.oldospoint,param.ospoint);
      end
      else KillOTrackTimer(@self)
    end
    else param.ospoint.ostype := os_none;

  end
  else param.ospoint.ostype := os_none;




  reprojectaxis;

  if (param.md.mode and (MGet3DPoint or MGet3DPointWoOp)) <> 0 then
     sendmousecoordwop(key);
    {if pcommandrunning <> nil then
    begin
      if param.ospoint.ostype <> os_none then pcommandrunning^.MouseMoveCallback(param.ospoint.worldcoord, param.md.mouse, 0)
      else begin
        if param.mouseonworkplan then
          pcommandrunning^.MouseMoveCallback(param.mouseonworkplanecoord,param.md.mouse, 0)
        else pcommandrunning^.MouseMoveCallback(param.glmcoord[0], param.md.mouse, 0);
      end;
    end;}
     //glGetDoublev(GL_MODELVIEW_MATRIX,@modelMatrix);
  //mouseunproject(param.md.mouse.x, param.md.mouse.y);
  //reprojectaxis;
  if param.seldesc.MouseFrameON then
  begin
    pdwg^.myGluProject2(param.seldesc.Frame13d,
               glmcoord1.lbegin);
    param.seldesc.Frame1.x := round(glmcoord1.lbegin.x);
    param.seldesc.Frame1.y := getviewcontrol.clientheight - round(glmcoord1.lbegin.y);
    if param.seldesc.Frame1.x < 0 then param.seldesc.Frame1.x := 0
    else if param.seldesc.Frame1.x > (getviewcontrol.clientwidth - 1) then param.seldesc.Frame1.x := getviewcontrol.clientwidth - 1;
    if param.seldesc.Frame1.y < 0 then param.seldesc.Frame1.y := 1
    else if param.seldesc.Frame1.y > (getviewcontrol.clientheight - 1) then param.seldesc.Frame1.y := getviewcontrol.clientheight - 1;
  end;
     //GDBobjinsp23.reread;
  //CalcOptimalMatrix;
  CalcOptimalMatrix;
  pdwg.GetConstructObjRoot.calcvisible(pdwg.Getpcamera^.frustum,pdwg.Getpcamera.POSCOUNT,pdwg.Getpcamera.VISCOUNT,pdwg.getpcamera.totalobj,pdwg.getpcamera.infrustum,pdwg.myGluProject2,pdwg.getpcamera.prop.zoom);

  //gdb.GetCurrentDWG.ConstructObjRoot.calcvisible(gdb.GetCurrentDWG.OGLwindow1.wa.param.mousefrustum);

  pdwg.GetSelObjArray.calcvisible(pdwg.Getpcamera^.frustum,pdwg.Getpcamera.POSCOUNT,pdwg.Getpcamera.VISCOUNT,pdwg.getpcamera.totalobj,pdwg.getpcamera.infrustum,pdwg.myGluProject2,pdwg.getpcamera.prop.zoom);
  Set3dmouse;

  f:=pdwg^.GetUnitsFormat;
  htext:=sysutils.Format('%s, %s, %s',[zeDimensionToString(param.md.mouse3dcoord.x,f),zeDimensionToString(param.md.mouse3dcoord.y,f),zeDimensionToString(param.md.mouse3dcoord.z,f)]);
  if param.polarlinetrace = 1 then
  begin
       htext2:=sysutils.Format('L=%s',[zeDimensionToString(param.ontrackarray.otrackarray[param.pointnum].tmouse,f)]);
       htext:=sysutils.Format('%s (%s)',[htext,htext2]);
       getviewcontrol.Hint:=htext2;
       Application.ActivateHint(getviewcontrol.ClientToScreen(Point(param.md.mouse.x,param.md.mouse.y)));
  end;


if PGDBObjEntity(param.SelDesc.OnMouseObject)<>nil then
                                                       begin
                                                            if PGDBObjEntity(param.SelDesc.OnMouseObject)^.vp.Layer._lock
                                                              then
                                                                  getviewcontrol.Cursor:=crNoDrop
                                                              else
                                                                  begin
                                                                       if assigned(sysvar.RD.RD_RemoveSystemCursorFromWorkArea)
                                                                       then
                                                                           RemoveCursorIfNeed(getviewcontrol,sysvar.RD.RD_RemoveSystemCursorFromWorkArea^)
                                                                       else
                                                                           RemoveCursorIfNeed(getviewcontrol,true)
                                                                  end;
                                                       end
                                                   else
                                                       if not param.scrollmode then
                                                                                   begin
                                                                                        if assigned(sysvar.RD.RD_RemoveSystemCursorFromWorkArea)
                                                                                        then
                                                                                            RemoveCursorIfNeed(getviewcontrol,sysvar.RD.RD_RemoveSystemCursorFromWorkArea^)
                                                                                        else
                                                                                            RemoveCursorIfNeed(getviewcontrol,true)
                                                                                   end;
  //Update objectinspector with mousemove
  //if assigned(GetCurrentObjProc) then
  //if GetCurrentObjProc=@sysvar then
  //If assigned(UpdateObjInspProc)then
  //                                 UpdateObjInspProc;


  SBTextOut(htext);
  //param.firstdraw:=true;
  //isOpenGLError;
  CorrectMouseAfterOS;
  draworinvalidate;
  //inc(sysvar.debug.int1);
  //debugvar(Variables,1);

  {$IFDEF PERFOMANCELOG}log.programlog.LogOutStrFast('TOGLWnd.Pre_MouseMove----{end}',lp_decPos);{$ENDIF}
end;
procedure TGeneralViewArea.asynczoomsel(Data: PtrInt);
begin
     ZoomSel();
end;
procedure TGeneralViewArea.asynczoomall(Data: PtrInt);
begin
     ZoomAll();
end;
procedure TGeneralViewArea.asyncupdatemouse(Data: PtrInt);
begin
     WaMouseMove(nil,[],param.md.mouse.x,param.md.mouse.y);
end;
destructor TGeneralViewArea.Destroy;
begin
     freeandnil(drawer);
     freeandnil(OTTimer);
     freeandnil(OHTimer);
     inherited;
end;

constructor TGeneralViewArea.Create(TheOwner: TComponent);
var
  i:integer;
  v:gdbvertex;
begin
     inherited;
     InsidePaintMessage:=0;
     drawer:=nil;

     WorkArea:=CreateWorkArea(TheOwner);
     CreateDrawer;
     SetupWorkArea;

     OTTimer:=TTimer.create(self);
     OHTimer:=TTimer.create(self);

     PDWG:=nil;

     param.projtype := Projparalel;
     param.firstdraw := true;
     param.SelDesc.OnMouseObject := nil;
     param.lastonmouseobject:=nil;
     param.SelDesc.LastSelectedObject := nil;
     param.pglscreen := nil;
     param.gluetocp := false;
     param.cpdist.cpnum := -1;
     param.cpdist.cpdist := 99999;

     SetMouseMode((MGetControlpoint) or (MGetSelectObject) or (MMoveCamera) or (MRotateCamera) or (MGetSelectionFrame));
     param.seldesc.MouseFrameON := false;
     param.otracktimerwork := 0;
     param.ontrackarray.total := 1;
     param.ontrackarray.current := 1;
     param.md.workplane{.normal.x}[0] := 0;
     param.md.workplane{.normal.y}[1] := {sqrt(0.1)}0;
     param.md.workplane{.normal.z}[2] := {sqrt(0.9)}1;
     param.md.workplane{.d}[3] := 0;
     param.scrollmode:=false;

     param.md.mousein:=false;
     param.processObjConstruct:=false;
     param.ShowDebugBoundingBbox:=false;
     param.ShowDebugFrustum:=false;
     param.CSIcon.AxisLen:=0;

     param.CSIcon.CSIconCoord:=nulvertex;
     param.CSIcon.CSIconX:=nulvertex;
     param.CSIcon.CSIconY:=nulvertex;

     param.CSIcon.CSIconZ:=nulvertex;

     PolarAxis.init({$IFDEF DEBUGBUILD}'{5AD9927A-0312-4844-8C2D-9498647CCECB}',{$ENDIF}10);

     for i := 0 to 4 - 1 do
     begin
       v.x:=cos(pi * i / 4);
       v.y:=sin(pi * i / 4);
       v.z:=0;
       PolarAxis.add(@v);
     end;

     param.ontrackarray.otrackarray[0].arrayworldaxis.init({$IFDEF DEBUGBUILD}'{8BE71BAA-507B-4D6B-BE2C-63693022090C}',{$ENDIF}10);
     param.ontrackarray.otrackarray[0].arraydispaxis.init({$IFDEF DEBUGBUILD}'{722A886F-5616-4E8F-B94D-3A1C3D7ADBD4}',{$ENDIF}10);
     tocommandmcliccount:=0;


     for i := 0 to 3 do
                     begin
                     param.ontrackarray.otrackarray[i].arrayworldaxis.init({$IFDEF DEBUGBUILD}'{722A886F-5616-4E8F-B94D-3A1C3D7ADBD4}',{$ENDIF}10);
                     param.ontrackarray.otrackarray[i].arrayworldaxis.CreateArray;
                     param.ontrackarray.otrackarray[i].arraydispaxis.init({$IFDEF DEBUGBUILD}'{722A886F-5616-4E8F-B94D-3A1C3D7ADBD4}',{$ENDIF}10);
                     param.ontrackarray.otrackarray[i].arraydispaxis.CreateArray;
                     end;


     param.ospoint.arraydispaxis.init({$IFDEF DEBUGBUILD}'{722A886F-5616-4E8F-B94D-3A1C3D7ADBD4}',{$ENDIF}10);
     param.ospoint.arrayworldaxis.init({$IFDEF DEBUGBUILD}'{722A886F-5616-4E8F-B94D-3A1C3D7ADBD4}',{$ENDIF}10);

     if PDWG<>nil then
     begin
     PDWG.Getpcamera^.obj_zmax:=-1;
     PDWG.Getpcamera^.obj_zmin:=100000;
     end;


     //OpenGLWindow.wa:=self;
     onCameraChanged:=nil;
     ShowCXMenu:=nil;
     MainMouseMove:=nil;
     MainMouseDown:=nil;

     WorkArea.onmouseup:=WaMouseUp;
     WorkArea.onmousedown:=WaMouseDown;
     WorkArea.onmousemove:=WaMouseMove;
     WorkArea.onmousewheel:=WaMouseWheel;
     WorkArea.onmouseenter:=WaMouseEnter;
     WorkArea.onmouseleave:=WaMouseLeave;
     WorkArea.onresize:=WaResize;
end;
function TGeneralViewArea.getviewcontrol:TCADControl;
begin
     result:=WorkArea;
end;
procedure TGeneralViewArea.WaMouseDown(Sender:TObject;Button: TMouseButton; Shift: TShiftState;X, Y: Integer);
var key: GDBByte;
    NeedRedraw:boolean;
    //menu:TmyPopupMenu;
    FreeClick:boolean;

  function ProcessControlpoint:boolean;
  begin
     begin
      result:=false;
      if param.gluetocp then
      begin
        PDWG.GetSelObjArray.selectcurrentcontrolpoint(key,param.md.mouseglue.x,param.md.mouseglue.y,param.height);
        needredraw:=true;
        result:=true;
        if (key and MZW_SHIFT) = 0 then
        begin
          param.startgluepoint:=param.nearesttcontrolpoint.pcontrolpoint;
          commandmanager.ExecuteCommandSilent('OnDrawingEd',pdwg,@param);
          //wa.param.lastpoint:=wa.param.nearesttcontrolpoint.pcontrolpoint^.worldcoord;
          //sendmousecoord{wop}(key);  bnmbnm
          if commandmanager.pcommandrunning <> nil then
          begin
            if key=MZW_LBUTTON then
                                   param.lastpoint:=param.nearesttcontrolpoint.pcontrolpoint^.worldcoord;
            commandmanager.pcommandrunning^.MouseMoveCallback(param.nearesttcontrolpoint.pcontrolpoint^.worldcoord,
                                                              param.md.mouseglue, key,nil)
          end;
        end;
      end;
    end;
  end;

  function ProcessEntSelect:boolean;
  var
      RelSelectedObjects:Integer;
  begin
    result:=false;
    begin
      getonmouseobjectbytree(PDWG.GetCurrentROOT.ObjArray.ObjTree);
      //getonmouseobject(@gdb.GetCurrentROOT.ObjArray);
      if (key and MZW_CONTROL)<>0 then
      begin
           commandmanager.ExecuteCommandSilent('SelectOnMouseObjects',pdwg,@param);
           result:=true;
      end
      else
      begin
      {//Выделение всех объектов под мышью
      if gdb.GetCurrentDWG.OnMouseObj.Count >0 then
      begin
           pobj:=gdb.GetCurrentDWG.OnMouseObj.beginiterate(ir);
           if pobj<>nil then
           repeat
                 pobj^.select;
                 wa.param.SelDesc.LastSelectedObject := pobj;
                 pobj:=gdb.GetCurrentDWG.OnMouseObj.iterate(ir);
           until pobj=nil;
        addoneobject;
        SetObjInsp;
      end}

      //Выделение одного объекта под мышью
      if param.SelDesc.OnMouseObject <> nil then
      begin
           result:=true;
           if (key and MZW_SHIFT)=0
           then
               begin
                    if assigned(sysvar.DSGN.DSGN_SelNew)then
                    if sysvar.DSGN.DSGN_SelNew^ then
                    begin
                          pdwg.GetCurrentROOT.ObjArray.DeSelect(pdwg.GetSelObjArray,param.SelDesc.Selectedobjcount);
                          param.SelDesc.LastSelectedObject := nil;
                          //wa.param.SelDesc.OnMouseObject := nil;
                          param.seldesc.Selectedobjcount:=0;
                          PDWG^.GetSelObjArray.clearallobjects;
                    end;
                    param.SelDesc.LastSelectedObject := param.SelDesc.OnMouseObject;
                    if assigned(OnWaMouseSelect)then
                      OnWaMouseSelect(self,param.SelDesc.LastSelectedObject);
               end
           else
               begin
                    PGDBObjEntity(param.SelDesc.OnMouseObject)^.DeSelect(PDWG^.GetSelObjArray,param.SelDesc.Selectedobjcount);
                    param.SelDesc.LastSelectedObject := nil;
                    //addoneobject;
                    SetObjInsp;
                    if assigned(updatevisibleproc) then updatevisibleproc;
               end;
               //wa.param.SelDesc.LastSelectedObject := wa.param.SelDesc.OnMouseObject;
               if commandmanager.pcommandrunning<>nil then
               if commandmanager.pcommandrunning.IData.GetPointMode=TGPWaitEnt then
               if param.SelDesc.LastSelectedObject<>nil then
               begin
                 commandmanager.pcommandrunning^.IData.GetPointMode:=TGPEnt;
               end;
           NeedRedraw:=true;
      end

      else if ((param.md.mode and MGetSelectionFrame) <> 0) and ((key and MZW_LBUTTON)<>0) then
      begin
        result:=true;
      { TODO : Добавить возможность выбора объектов без секрамки во время выполнения команды }
        commandmanager.ExecuteCommandSilent('SelectFrame',pdwg,@param);
        sendmousecoord(MZW_LBUTTON);
      end;
    end;
    end;
  end;

begin
  FreeClick:=true;
  if assigned(zcadinterface.SetNormalFocus)then
                                               zcadinterface.SetNormalFocus(nil);
  if assigned(MainmouseDown)then
  if mainmousedown then
                       exit;
  //if (cxmenumgr.ismenupopup)or(ActivePopupMenu<>nil) then
  //                                                       exit;
  if @SetCurrentDWGProc<>nil then
                                SetCurrentDWGProc(pdwg);
  //ActivePopupMenu:=ActivePopupMenu;
  NeedRedraw:=false;
  if assigned(OnWaMouseDown) then
  if OnWaMouseDown(self,Button,Shift,X, Y,param.SelDesc.OnMouseObject) then
    exit;
  if ssDouble in shift then
                           begin
                                if mbMiddle=button then
                                  begin
                                       {$IFNDEF DELPHI}
                                       if ssShift in shift then
                                                               Application.QueueAsyncCall(asynczoomsel, 0)
                                                           else
                                                               Application.QueueAsyncCall(asynczoomall, 0);
                                       {$ENDIF}
                                       //Pre_MBMouseDblClk(Button,Shift,X, Y);
                                       {exclude(shift,ssdouble);
                                       exclude(shift,ssMiddle);}
                                       exit;
                                  end;
                           end;
  if ssRight in shift then
                           begin
                                if assigned(ShowCXMenu)then
                                                           ShowCXMenu;
                                exit;
                           end;
  (*if wa.PDWG<>pointer(gdb.GetCurrentDWG) then
                                 begin
                                      //r.handled:=true;
                                      gdb.SetCurrentDWG(wa.pdwg);
                                      self.wa.param.firstdraw:=true;
                                      paint;
                                      MyglMakeCurrent(OGLContext);//wglMakeCurrent(DC, hrc);//initogl;

                                 end
                              else*)

  begin
  //r.handled:=true;
  if pdwg=nil then exit;
  key := 0;
  if (ssLeft in shift) then
                           key := key or MZW_LBUTTON;
  if (ssShift in shift) then key := key or MZW_SHIFT;
  if (ssCtrl in shift) then key := key or MZW_CONTROL;
  if (ssMiddle in shift) then
  begin
    WorkArea.cursor := crHandPoint;
    param.scrollmode:=true;
    param.lastonmouseobject := nil;
  end;
  param.md.mouse.x := x;
  param.md.mouse.y := y;
  if (ssLeft in shift) then
    //---------------------------------------------------------if commandmanager.pcommandrunning = nil then
    begin
      if (param.md.mode and MGetControlpoint) <> 0 then
                                                       FreeClick:=not ProcessControlpoint;

        {else} if FreeClick and((param.md.mode and MGetSelectObject) <> 0) then
        FreeClick:=not ProcessEntSelect;
        needredraw:=true;
    end;
    //---------------------------------------------------------else
    begin
      if FreeClick and((param.md.mode and (MGet3DPoint or MGet3DPointWoOP)) <> 0) then
      begin
        //if commandmanager.pcommandrunning <> nil then
        //                                             FreeClick:=false;
        sendmousecoordwop(key);
        //GDBFreeMem(GDB.PObjPropArray^.propertyarray[0].pobject);
      end;
       {if FreeClick and(((wa.param.md.mode and MGetSelectionFrame) <> 0) and ((key and MZW_LBUTTON)<>0)) then
          begin
            commandmanager.ExecuteCommandSilent('SelectFrame',wa.pdwg,@wa.param);
            sendmousecoord(MZW_LBUTTON);
            FreeClick:=false;
          end;}
      needredraw:=true;
    end;
    If assigned(UpdateObjInspProc)then
    UpdateObjInspProc;
  end;
  inherited;
  if needredraw then
                    if assigned(redrawoglwndproc) then redrawoglwndproc;
end;

procedure TGeneralViewArea.WaMouseUp(Sender:TObject;Button: TMouseButton; Shift:TShiftState;X, Y: Integer);
//procedure TOGLWnd.Pre_MouseUp;
begin
  inherited;
  if button = mbMiddle then
  begin
    if assigned(sysvar.RD.RD_RemoveSystemCursorFromWorkArea)
    then
        RemoveCursorIfNeed(WorkArea,sysvar.RD.RD_RemoveSystemCursorFromWorkArea^)
    else
        RemoveCursorIfNeed(WorkArea,true);
    param.scrollmode:=false;
    param.firstdraw:=true;
    WorkArea.invalidate;
    //paint;
  end;
  if assigned(GetCurrentObjProc) then
  if GetCurrentObjProc=@sysvar then
  If assigned(UpdateObjInspProc)then
                                   UpdateObjInspProc;
  if assigned(zcadinterface.SetNormalFocus)then
                                               zcadinterface.SetNormalFocus(nil);
end;

procedure TGeneralViewArea.sendmousecoord(key: GDBByte);
begin
  if commandmanager.pcommandrunning <> nil then
    if param.md.mouseonworkplan
    then
        begin
             sendcoordtocommand(param.md.mouseonworkplanecoord,key);
             //if key=MZW_LBUTTON then wa.param.lastpoint:=wa.param.md.mouseonworkplanecoord;
             //commandmanager.pcommandrunning^.MouseMoveCallback(wa.param.md.mouseonworkplanecoord, wa.param.md.mouse, key,nil)
        end
    else
        begin
             sendcoordtocommand(param.md.mouseray.lbegin,key);
             //if key=MZW_LBUTTON then wa.param.lastpoint:=wa.param.md.mouseray.lbegin;
             //commandmanager.pcommandrunning^.MouseMoveCallback(wa.param.md.mouseray.lbegin, wa.param.md.mouse, key,nil);
        end;
    //if key=MZW_LBUTTON then wa.param.ontrackarray.otrackarray[0].worldcoord:=wa.param.md.mouseonworkplanecoord;
end;
procedure TGeneralViewArea.sendmousecoordwop(key: GDBByte);
var
   tv:gdbvertex;
begin
  if commandmanager.pcommandrunning <> nil then
    if param.ospoint.ostype <> os_none
    then
    begin
         begin
              {if (key and MZW_LBUTTON)<>0 then
                                              shared.HistoryOutStr(floattostr(wa.param.ospoint.ostype));}
              tv:=param.ospoint.worldcoord;
              if (key and MZW_SHIFT)<>0 then
                                            begin
                                                 key:=key and (not MZW_SHIFT);
                                                 tv:=Vertexmorphabs(param.lastpoint,param.ospoint.worldcoord,1);
                                            end;
              if (key and MZW_CONTROL)<>0 then
                                            begin
                                                 key:=key and (not MZW_CONTROL);
                                                 tv:=Vertexmorphabs(param.lastpoint,param.ospoint.worldcoord,-1);
                                            end;
              key:=key and (not MZW_CONTROL);
              key:=key and (not MZW_SHIFT);

              {if key=MZW_LBUTTON then
                                     begin
                                          inc(tocommandmcliccount);
                                          wa.param.ontrackarray.otrackarray[0].worldcoord:=tv;
                                     end;
              if (key and MZW_LBUTTON)<>0 then
                                              wa.param.lastpoint:=tv;
              commandmanager.pcommandrunning^.MouseMoveCallback(tv, wa.param.md.mouse, key,@wa.param.ospoint);}

              sendcoordtocommandTraceOn(tv,key,@param.ospoint)
         end;
    end
    else
    begin
        {if key=MZW_LBUTTON then
                               begin
                               inc(tocommandmcliccount);
                               wa.param.ontrackarray.otrackarray[0].worldcoord:=wa.param.md.mouseonworkplanecoord;
                               end;}
        if param.md.mouseonworkplan
        then
            begin
                 if sysvar.DWG.DWG_SnapGrid<>nil then
                 if not sysvar.DWG.DWG_SnapGrid^ then
                 param.ospoint.worldcoord:=param.md.mouseonworkplanecoord;
                 sendcoordtocommandTraceOn({wa.param.md.mouseonworkplanecoord}param.ospoint.worldcoord,key,nil)
                 //if key=MZW_LBUTTON then wa.param.lastpoint:=wa.param.md.mouseonworkplanecoord;
                 //commandmanager.pcommandrunning.MouseMoveCallback(wa.param.md.mouseonworkplanecoord, wa.param.md.mouse, key,nil)
            end
        else
            begin
                 param.ospoint.worldcoord:=param.md.mouseray.lbegin;
                 sendcoordtocommandTraceOn(param.md.mouseray.lbegin,key,nil)
                 //if key=MZW_LBUTTON then wa.param.lastpoint:=wa.param.md.mouseray.lbegin;
                 //commandmanager.pcommandrunning^.MouseMoveCallback(wa.param.md.mouseray.lbegin, wa.param.md.mouse, key,nil);
            end;
    end;
end;

procedure TGeneralViewArea.sendcoordtocommand(coord:GDBVertex;key: GDBByte);
begin
     if key=MZW_LBUTTON then param.lastpoint:=coord;
     commandmanager.sendpoint2command(coord, param.md.mouse, key,nil,pdwg^);
end;

procedure TGeneralViewArea.sendcoordtocommandTraceOn(coord:GDBVertex;key: GDBByte;pos:pos_record);
var
   cs:integer;
begin
     //if commandmanager.pcommandrunning<>nil then
     //if commandmanager.pcommandrunning.IsRTECommand then
    cs:=commandmanager.CommandsStack.Count;
        commandmanager.sendpoint2command(coord,param.md.mouse,key,pos,pdwg^);

     if (key and MZW_LBUTTON)<>0 then
     if (commandmanager.pcommandrunning<>nil)and(cs=commandmanager.CommandsStack.Count) then
     begin
           inc(tocommandmcliccount);
           param.ontrackarray.otrackarray[0].worldcoord:=coord;
           param.lastpoint:=coord;
           create0axis;
           project0axis;
     end;
     //end;
end;
function TGeneralViewArea.CreateRC(_maxdetail:GDBBoolean=false):TDrawContext;
begin
  result.Subrender:=0;
  result.Selected:=false;
  result.VisibleActualy:=PDWG.Getpcamera.POSCOUNT;
  result.InfrustumActualy:=PDWG.Getpcamera.POSCOUNT;
  result.DRAWCOUNT:=PDWG.Getpcamera.DRAWCOUNT;
  result.SysLayer:=PDWG.GetLayerTable.GetSystemLayer;
  result.MaxDetail:=_maxdetail;

  if sysvar.dwg.DWG_DrawMode<>nil then
                                      result.DrawMode:=sysvar.dwg.DWG_DrawMode^
                                  else
                                      result.DrawMode:=true;
  result.OwnerLineWeight:=-3;
  result.OwnerColor:=ClWhite;
  if assigned(sysvar.RD.RD_MaxWidth)then
                                        result.MaxWidth:=sysvar.RD.RD_MaxWidth^
                                    else
                                        result.MaxWidth:=20;
  result.ScrollMode:=param.scrollmode;
  result.Zoom:=PDWG.GetPcamera.prop.zoom;
  result.drawer:=drawer;
  result.matrixs.pmodelMatrix:=@PDWG.GetPcamera.modelMatrix;
  result.matrixs.pprojMatrix:=@PDWG.GetPcamera.projMatrix;
  result.matrixs.pviewport:=@PDWG.GetPcamera.viewport;
  result.pcamera:=PDWG.GetPcamera;
end;
procedure TGeneralViewArea.CorrectMouseAfterOS;
var d,tv1,tv2:GDBVertex;
    b1,b2:GDBBoolean;
begin
     param.md.mouseraywithoutos:=param.md.mouseray;
     if (param.ospoint.ostype <> os_none)or(currentmousemovesnaptogrid) then
     begin

     if param.projtype = ProjParalel then
     begin
          d:=pdwg.getpcamera^.prop.look;
          b1:=PointOfLinePlaneIntersect(param.ospoint.worldcoord,d,pdwg.getpcamera^.frustum[4],tv1);
          b2:=PointOfLinePlaneIntersect(param.ospoint.worldcoord,d,pdwg.getpcamera^.frustum[5],tv2);
          if (b1 and b2) then
                             begin
                                  param.md.mouseray.lbegin:=tv1;
                                  param.md.mouseray.lend:=tv2;
                                  param.md.mouseray.dir:=vertexsub(tv2,tv1);
                             end;
     end
     else
     begin
         d:=VertexSub(param.ospoint.worldcoord,pdwg.getpcamera^.prop.point);
         //d:=gdb.GetCurrentDWG.pcamera^.prop.look;
         b1:=PointOfLinePlaneIntersect(param.ospoint.worldcoord,d,pdwg.getpcamera^.frustum[4],tv1);
         b2:=PointOfLinePlaneIntersect(param.ospoint.worldcoord,d,pdwg.getpcamera^.frustum[5],tv2);
         if (b1 and b2) then
                            begin
                                 param.md.mouseray.lbegin:=tv1;
                                 param.md.mouseray.lend:=tv2;
                                 param.md.mouseray.dir:=vertexsub(tv2,tv1);
                            end;
         pdwg^.myGluUnProject(createvertex(param.ospoint.dispcoord.x, param.ospoint.dispcoord.y, 0),param.md.mouseray.lbegin);
         pdwg^.myGluUnProject(createvertex(param.ospoint.dispcoord.x, param.ospoint.dispcoord.y, 1),param.md.mouseray.lend);
     end;
     end;
end;
procedure TGeneralViewArea.AddOntrackpoint;
begin
  if not sysvar.dwg.DWG_PolarMode^ then exit;
  copyospoint(param.ontrackarray.otrackarray[param.ontrackarray.current],param.ospoint);
  param.ontrackarray.otrackarray[param.ontrackarray.current].arrayworldaxis.clear;
  param.ontrackarray.otrackarray[param.ontrackarray.current].arraydispaxis.clear;
  param.ospoint.arrayworldaxis.copyto(@param.ontrackarray.otrackarray[param.ontrackarray.current].arrayworldaxis);
  param.ospoint.arraydispaxis.copyto(@param.ontrackarray.otrackarray[param.ontrackarray.current].arraydispaxis);


  inc(param.ontrackarray.current);
  if param.ontrackarray.current = maxtrackpoint then
  begin
    param.ontrackarray.current := 1;
  end;
  if param.ontrackarray.total < maxtrackpoint then
  begin
    inc(param.ontrackarray.total);
  end;
end;

procedure TGeneralViewArea.processmousenode(Node:TEntTreeNode;var i:integer);
//var
  //pp:PGDBObjEntity;
  //ir:itrec;
  //inr:TINRect;
begin
     if CalcAABBInFrustum (Node.BoundingBox,param.mousefrustum)<>IREmpty then
     begin
          findonmobj(@node.nul, i);
          if assigned(node.pminusnode) then
                                           processmousenode(node.pminusnode^,i);
          if assigned(node.pplusnode) then
                                           processmousenode(node.pplusnode^,i);
     end;
end;

procedure TGeneralViewArea.getonmouseobjectbytree(Node:TEntTreeNode);
var
  i: GDBInteger;
  pp:PGDBObjEntity;
  ir:itrec;
  //inr:TINRect;
  DC:TDrawContext;
begin
  {$IFDEF PERFOMANCELOG}log.programlog.LogOutStrFast('TOGLWnd.getonmouseobjectbytree',lp_IncPos);{$ENDIF}
  i := 0;
  PDWG.GetOnMouseObj.clear;
  param.SelDesc.OnMouseObject := nil;


  processmousenode(Node,i);
  if param.processObjConstruct then
                                   findonmobj(@PDWG.GetConstructObjRoot.ObjArray,i);

  pp:=PDWG.GetOnMouseObj.beginiterate(ir);
  if pp<>nil then
                 begin
                      param.lastonmouseobject:=pp;
                      dc:=CreateRC;
                      repeat
                            if pp^.vp.LastCameraPos<>PDWG.Getpcamera^.POSCOUNT then
                            pp^.RenderFeedback(PDWG.Getpcamera^.POSCOUNT,PDWG.Getpcamera^,PDWG.myGluProject2,dc);


                            pp:=PDWG.GetOnMouseObj.iterate(ir);
                      until pp=nil;
                 end;

  {gdb.GetCurrentDWG.OnMouseObj.clear;
  param.SelDesc.OnMouseObject := nil;
  param.lastonmouseobject:=nil;}

  {$IFDEF PERFOMANCELOG}log.programlog.LogOutStrFast('TOGLWnd.getonmouseobjectbytree------{end}',lp_DecPos);{$ENDIF}
end;

function TGeneralViewArea.findonmobj(pva: PGDBObjEntityOpenArray; var i: GDBInteger): GDBInteger;
var
  pp:PGDBObjEntity;
  ir:itrec;
  _total,_visible,_isonmouse:integer;
begin
  {$IFDEF PERFOMANCELOG}log.programlog.LogOutStrFast('TOGLWnd.findonmobj',lp_IncPos);{$ENDIF}
  if not param.scrollmode then
  begin
  _total:=0;
  _visible:=0;
  _isonmouse:=0;
  pp:=pva^.beginiterate(ir);
  if pp<>nil then
  repeat
       inc(_total);
       if pp^.visible=PDWG.Getpcamera.VISCOUNT then
       begin
       inc(_visible);
       if pp^.isonmouse(PDWG.GetOnMouseObj^,param.mousefrustum)
       then
           begin
                inc(_isonmouse);
                pp:=pp.ReturnLastOnMouse;
                param.SelDesc.OnMouseObject:=pp;
                PDWG.GetOnMouseObj.add(addr(pp));
           end;

       end;
  pp:=pva^.iterate(ir);
  until pp=nil;
  {$IFDEF PERFOMANCELOG}log.programlog.LogOutStrFast('Total:='+inttostr(_total)+'; Visible:='+inttostr(_visible)+'; IsOnMouse:='+inttostr(_isonmouse),0);{$ENDIF}
  end
  else {$IFDEF PERFOMANCELOG}log.programlog.LogOutStrFast('wa.param.scrollmode=true. exit',0);{$ENDIF}
  {$IFDEF PERFOMANCELOG}log.programlog.LogOutStrFast('TOGLWnd.findonmobj-----{end}',lp_DecPos);{$ENDIF}
end;

procedure TGeneralViewArea.getonmouseobject;
var
  i: GDBInteger;
  pp:PGDBObjEntity;
  ir:itrec;
  DC:TDrawContext;
begin
  {$IFDEF PERFOMANCELOG}log.programlog.LogOutStrFast('TOGLWnd.getonmouseobject',lp_IncPos);{$ENDIF}
  i := 0;
  PDWG.GetOnMouseObj.clear;
  param.SelDesc.OnMouseObject := nil;
  findonmobj(pva, i);
  pp:=PDWG.GetOnMouseObj.beginiterate(ir);
  if pp<>nil then
                 begin
                     param.lastonmouseobject:=pp;
                     dc:=CreateRC;
                      repeat
                            if pp^.vp.LastCameraPos<>PDWG.Getpcamera^.POSCOUNT then
                            pp^.RenderFeedback(PDWG.Getpcamera^.POSCOUNT,PDWG.Getpcamera^,PDWG.myGluProject2,dc);


                            pp:=PDWG.GetOnMouseObj.iterate(ir);
                      until pp=nil;
                 end;

  {gdb.GetCurrentDWG.OnMouseObj.clear;
  wa.param.SelDesc.OnMouseObject := nil;
  wa.param.lastonmouseobject:=nil;}

  {$IFDEF PERFOMANCELOG}log.programlog.LogOutStrFast('TOGLWnd.getonmouseobject------{end}',lp_DecPos);{$ENDIF}
end;
procedure TGeneralViewArea.getosnappoint({pva: PGDBObjEntityOpenArray; }radius: GDBFloat);
var
  pv,pv2:PGDBObjEntity;
  osp:os_record;
  dx,dy:GDBDouble;
//  oldit:itrec;
      ir,ir2:itrec;
  pdata:GDBPointer;
  DefaultRadius,DefaultTextRadius:GDBDouble;
begin
  DefaultRadius:=sysvar.DISP.DISP_CursorSize^*sysvar.DISP.DISP_CursorSize^+1;
  DefaultTextRadius:=(5*5)*DefaultRadius;
  param.ospoint.radius:=DefaultRadius;
  param.ospoint.ostype:=os_none;
      if param.md.mouseonworkplan
      then
          begin
               param.ospoint.worldcoord:=param.md.mouseonworkplanecoord;
               if SysVar.DWG.DWG_SnapGrid<>nil then
               if SysVar.DWG.DWG_SnapGrid^ then
               begin
                    param.ospoint.worldcoord:=correcttogrid(param.ospoint.worldcoord);
                    //param.ospoint.worldcoord.x:=round((param.md.mouseonworkplanecoord.x-SysVar.DWG.DWG_OriginGrid.x)/SysVar.DWG.DWG_StepGrid.x)*SysVar.DWG.DWG_StepGrid.x+SysVar.DWG.DWG_OriginGrid.x;
                    //param.ospoint.worldcoord.y:=round((param.md.mouseonworkplanecoord.y-SysVar.DWG.DWG_OriginGrid.y)/SysVar.DWG.DWG_StepGrid.y)*SysVar.DWG.DWG_StepGrid.y+SysVar.DWG.DWG_OriginGrid.y;
                    param.ospoint.ostype:=os_snap;
                    currentmousemovesnaptogrid:=true;
               end;
          end
      else
          begin
               param.ospoint.worldcoord:=param.md.mouseray.lbegin;
          end;

  param.ospoint.PGDBObject:=nil;
  if (param.scrollmode)or(PDWG.GetOnMouseObj.Count=0)then exit;
  if PDWG.GetOnMouseObj.Count>0 then
     begin
     pv:=PDWG.GetOnMouseObj.beginiterate(ir);
     if pv<>nil then
     repeat
     begin
       pv.startsnap(osp,pdata);
       while pv.getsnap(osp,pdata,param,pdwg.myGluProject2) do
       begin
            if osp.ostype<>os_none then
            begin
            dx:=osp.dispcoord.x-param.md.glmouse.x;
            dy:=osp.dispcoord.y-param.md.glmouse.y;
            osp.radius:=dx*dx+dy*dy;
            if osp.ostype<>os_nearest
            then
            begin
                 if param.ospoint.ostype=os_nearest then
                 begin
                      if (osp.radius<DefaultRadius) then copyospoint(param.ospoint,osp);
                 end
                 else
                 if (osp.radius<=param.ospoint.radius)or(osp.ostype=os_textinsert) then
                                                                                       begin
                                                                                            if (osp.radius<param.ospoint.radius) then
                                                                                                                                     begin
                                                                                                                                     if osp.ostype<param.ospoint.ostype then
                                                                                                                                          copyospoint(param.ospoint,osp)

                                                                                                                                     end
                                                                                       else
                                                                                           if ((osp.ostype<>os_perpendicular)and(osp.ostype<>os_textinsert))or((osp.ostype=os_textinsert)and (osp.radius<=DefaultTextRadius)) then
                                                                                                                                     copyospoint(param.ospoint,osp)
                                                                                       end;
            end
            else
            begin
                 if (osp.radius<DefaultRadius)and(param.ospoint.ostype=os_none) then copyospoint(param.ospoint,osp)
                 else if param.ospoint.ostype=os_nearest then
                                                            if {(osp.radius<sysvar.DISP.DISP_CursorSize^*sysvar.DISP.DISP_CursorSize^+1)and}(osp.radius<param.ospoint.radius) then
                                                                                                   copyospoint(param.ospoint,osp);
            end;
            end;
       end;
       pv.endsnap(osp,pdata);
     end;
     pv:=PDWG.GetOnMouseObj.iterate(ir);
     until pv=nil;
     end;
  if ((sysvar.dwg.DWG_OSMode^ and osm_apparentintersection)<>0)or((sysvar.dwg.DWG_OSMode^ and osm_intersection)<>0)then
  begin
  if (PDWG.GetOnMouseObj.Count>1)and(PDWG.GetOnMouseObj.Count<10) then
  begin
  pv:=PDWG.GetOnMouseObj.beginiterate(ir);
  repeat
  if pv<>nil then
  begin
  pv2:=PDWG.GetOnMouseObj.beginiterate(ir2);
  if pv2<>nil then
  repeat
  if pv<>pv2 then
  begin
       pv.startsnap(osp,pdata);
       while pv.getintersect(osp,pv2,param,PDWG.myGluProject2) do
       begin
            if osp.ostype<>os_none then
            begin
            dx:=osp.dispcoord.x-param.md.glmouse.x;
            dy:=osp.dispcoord.y-param.md.glmouse.y;
            osp.radius:=dx*dx+dy*dy;
            if (osp.radius<=param.ospoint.radius) then
            begin
                 if param.ospoint.ostype=os_nearest then
                 begin
                      if (osp.radius<DefaultRadius) then copyospoint(param.ospoint,osp);
                 end
                 else
                 //if (osp.radius<param.ospoint.radius) then copyospoint(param.ospoint,osp);
                 if param.ospoint.ostype=os_none        then copyospoint(param.ospoint,osp);

            end
            end;
       end;
       pv.endsnap(osp,pdata);
  end;
  pv2:=PDWG.GetOnMouseObj.iterate(ir2);
  until pv2=nil;
  end;
  pv:=PDWG.GetOnMouseObj.iterate(ir);
  until pv=nil;
  end;
  end;
end;

procedure TGeneralViewArea.ProcOTrackTimer(Sender:TObject);
begin
  //timeKillEvent(uEventID);
  otracktimer := 1;
  OTTimer.Interval:=0;
  OTTimer.Enabled:=false;
end;
procedure TGeneralViewArea.KillOTrackTimer(Sender: TObject);
begin
  if param.otracktimerwork = 0 then exit;
  dec(param.otracktimerwork);
  OTTimer.Interval:=0;
  OTTimer.Enabled:=false;
  //timeKillEvent(uEventID);
end;
procedure TGeneralViewArea.SetOTrackTimer(Sender: TObject);
var
   interval:integer;
begin
  if param.otracktimerwork = 1 then exit;
  inc(param.otracktimerwork);
  if param.otracktimerwork > 0 then
                                   begin
                                        if assigned(sysvar.DSGN.DSGN_OTrackTimerInterval) then
                                        begin
                                             if sysvar.DSGN.DSGN_OTrackTimerInterval^>0 then
                                                                                            interval:=sysvar.DSGN.DSGN_OTrackTimerInterval^
                                                                                        else
                                                                                            interval:=0;
                                        end
                                        else interval:=500;
                                        OTTimer.Interval:=interval;
                                        OTTimer.OnTimer:=ProcOTrackTimer;
                                        OTTimer.Enabled:=true;

                                   end;
end;
procedure TGeneralViewArea.KillOHintTimer(Sender: TObject);
begin
  OHTimer.Interval:=0;
  OHTimer.Enabled:=false;
end;

procedure TGeneralViewArea.SetOHintTimer(Sender: TObject);
begin
    if assigned(OnGetEntsDesc)then
                                  getviewcontrol.Hint:=OnGetEntsDesc(PDWG^.GetOnMouseObj)
                              else
                                  getviewcontrol.Hint:='';
    getviewcontrol.ShowHint:=true;
    if getviewcontrol.hint<>'' then
    Application.ActivateHint(getviewcontrol.ClientToScreen(Point(param.md.mouse.x,param.md.mouse.y)))
    else
        application.CancelHint;

                                   begin
                                        //uEventID := timeSetEvent(500, 250, @ProcTime, 0, 1)
                                        OHTimer.Interval:=500;
                                        //wa.OHTimer.OnTimer:=ProcOHintTimer;
                                        OHTimer.Enabled:=true;

                                   end;
end;
procedure TGeneralViewArea.CalcMouseFrustum;
var
  tm: DMatrix4D;
  td:gdbdouble;
begin
  td:=sysvar.DISP.DISP_CursorSize^*2;
  param.mousefrustum   :=CalcDisplaySubFrustum(param.md.glmouse.x,param.md.glmouse.y,td,td,PDWG.Getpcamera.modelMatrix,PDWG.Getpcamera.projMatrix,PDWG.Getpcamera.viewport);
  param.mousefrustumLCS:=CalcDisplaySubFrustum(param.md.glmouse.x,param.md.glmouse.y,td,td,PDWG.Getpcamera.modelMatrixLCS,PDWG.Getpcamera.projMatrixLCS,PDWG.Getpcamera.viewport);
  exit;
  {
  tm:=lookat(param.md.mouseray.lbegin,
             gdb.GetCurrentDWG.pcamera^.xdir,
             gdb.GetCurrentDWG.pcamera^.ydir,
             normalizevertex(param.md.mouseray.dir),@onematrix);
  if param.projtype = ProjParalel then
                                      begin

                                      param.mouseclipmatrix:=ortho(-sysvar.DISP.DISP_CursorSize^*param.zoom*2,sysvar.DISP.DISP_CursorSize^*param.zoom*2,
                                                                   -sysvar.DISP.DISP_CursorSize^*param.zoom*2,sysvar.DISP.DISP_CursorSize^*param.zoom*2,
                                                                   gdb.GetCurrentDWG.pcamera^.zmin, gdb.GetCurrentDWG.pcamera^.zmax,@onematrix);
                                      param.mouseclipmatrix:=MatrixMultiply(tm,param.mouseclipmatrix);
                                      param.mousefrustum:=calcfrustum(@param.mouseclipmatrix);
                                      end;

}
  //--oglsm.myglMatrixMode(GL_Projection);
  //--oglsm.myglpushmatrix;
  //--oglsm.myglLoadIdentity;
  tm:=myPickMatrix(param.md.glmouse.x, param.md.glmouse.y, sysvar.DISP.DISP_CursorSize^ * 2, sysvar.DISP.DISP_CursorSize^ * 2, PDWG.Getpcamera^.viewport);
  //--oglsm.mygluPickMatrix(param.md.glmouse.x, param.md.glmouse.y, sysvar.DISP.DISP_CursorSize^ * 2, sysvar.DISP.DISP_CursorSize^ * 2, (@PDWG.Getpcamera^.viewport));
  //--oglsm.myglGetDoublev(GL_PROJECTION_MATRIX, @tm);
  param.mouseclipmatrix := MatrixMultiply(PDWG.Getpcamera^.projMatrix, tm);
  param.mouseclipmatrix := MatrixMultiply(PDWG.Getpcamera^.modelMatrix, param.mouseclipmatrix);
  param.mousefrustum := calcfrustum(@param.mouseclipmatrix);
  //--oglsm.myglpopmatrix;
  //--oglsm.myglMatrixMode(GL_MODELVIEW);
end;

function ProjectPoint2(pntx,pnty,pntz:gdbdouble; var m:DMatrix4D; var ccsLBN,ccsRTF:GDBVertex):gdbvertex;
begin
     result.x:=pntx;
     result.y:=pnty;
     result.z:=pntz;
     result:=geometry.VectorTransform3D(result,m);

     if result.x<ccsLBN.x then
                              begin
                                   ccsLBN.x:=result.x;
                              end;
                          //else
     if result.y<ccsLBN.y then
                              begin
                                   ccsLBN.y:=result.y;
                              end;
                          //else
     if result.z<ccsLBN.z then
                              begin
                                   ccsLBN.z:=result.z;
                              end;
                          //else
     if result.x>ccsRTF.x then
                              begin
                                   ccsRTF.x:=result.x;
                              end;
                          //else
     if result.y>ccsRTF.y then
                              begin
                                   ccsRTF.y:=result.y;
                              end ;
                          //else
     if result.z>ccsRTF.z then
                              begin
                                   ccsRTF.z:=result.z;
                              end;
end;

procedure TGeneralViewArea.CalcOptimalMatrix;
var ccsLBN,ccsRTF:GDBVertex;
    tm:DMatrix4D;
    LBN:GDBvertex;(*'ЛевыйНижнийБлижний'*)
    RTF:GDBvertex;
    tbb,tbb2:TBoundingBox;
    //wa.pdwg:PTDrawing;
    proot:PGDBObjGenericSubEntry;
    pcamera:PGDBObjCamera;
    td:GDBDouble;
begin
  {$IFDEF PERFOMANCELOG}log.programlog.LogOutStrFast('TOGLWnd.CalcOptimalMatrix',lp_IncPos);{$ENDIF}
  {Если нет примитивов выходим}
  //pdwg:=gdb.GetCurrentDWG;
  //self.MakeCurrent;
  if pdwg=nil then exit;
  proot:=PDWG.GetCurrentROOT;
  pcamera:=pdwg.getpcamera;

  if (assigned(pdwg))and(assigned(proot))and(assigned(pcamera))then
  begin
  Pcamera^.modelMatrix:=lookat(Pcamera^.prop.point,
                                               Pcamera^.prop.xdir,
                                               Pcamera^.prop.ydir,
                                               Pcamera^.prop.look,@onematrix);
  //glGetDoublev(GL_MODELVIEW_MATRIX, @pdwg.pcamera^.modelMatrix);

  {pdwg.pcamera^.modelMatrix[0][0]:=pdwg.pcamera^.modelMatrix[0][0]/1e5;
  pdwg.pcamera^.modelMatrix[1][1]:=pdwg.pcamera^.modelMatrix[1][1]/1e5;
  pdwg.pcamera^.modelMatrix[2][2]:=pdwg.pcamera^.modelMatrix[2][2]/1e5;

  pdwg.pcamera^.modelMatrix[3][0]:=pdwg.pcamera^.modelMatrix[3][0]/1e5;
  pdwg.pcamera^.modelMatrix[3][1]:=pdwg.pcamera^.modelMatrix[3][1]/1e5;
  pdwg.pcamera^.modelMatrix[3][2]:=pdwg.pcamera^.modelMatrix[3][2]/1e5;

  pdwg.pcamera^.modelMatrix[3][3]:=pdwg.pcamera^.modelMatrix[3][3]*1e5;}

  ccsLBN:=InfinityVertex;
  ccsRTF:=MinusInfinityVertex;
  {ProjectPoint2(proot.vp.BoundingBox.LBN.x,proot.vp.BoundingBox.LBN.y,proot.vp.BoundingBox.LBN.Z,pdwg.pcamera^.modelMatrix,ccsLBN,ccsRTF);
  ProjectPoint2(proot.vp.BoundingBox.RTF.x,proot.vp.BoundingBox.LBN.y,proot.vp.BoundingBox.LBN.Z,pdwg.pcamera^.modelMatrix,ccsLBN,ccsRTF);
  ProjectPoint2(proot.vp.BoundingBox.RTF.x,proot.vp.BoundingBox.RTF.y,proot.vp.BoundingBox.LBN.Z,pdwg.pcamera^.modelMatrix,ccsLBN,ccsRTF);
  ProjectPoint2(proot.vp.BoundingBox.LBN.x,proot.vp.BoundingBox.RTF.y,proot.vp.BoundingBox.LBN.Z,pdwg.pcamera^.modelMatrix,ccsLBN,ccsRTF);
  ProjectPoint2(proot.vp.BoundingBox.LBN.x,proot.vp.BoundingBox.LBN.y,proot.vp.BoundingBox.RTF.Z,pdwg.pcamera^.modelMatrix,ccsLBN,ccsRTF);
  ProjectPoint2(proot.vp.BoundingBox.RTF.x,proot.vp.BoundingBox.LBN.y,proot.vp.BoundingBox.RTF.Z,pdwg.pcamera^.modelMatrix,ccsLBN,ccsRTF);
  ProjectPoint2(proot.vp.BoundingBox.RTF.x,proot.vp.BoundingBox.RTF.y,proot.vp.BoundingBox.RTF.Z,pdwg.pcamera^.modelMatrix,ccsLBN,ccsRTF);
  ProjectPoint2(proot.vp.BoundingBox.LBN.x,proot.vp.BoundingBox.RTF.y,proot.vp.BoundingBox.RTF.Z,pdwg.pcamera^.modelMatrix,ccsLBN,ccsRTF);
  }
  {ProjectPoint2(proot.VisibleOBJBoundingBox.LBN.x,proot.VisibleOBJBoundingBox.LBN.y,proot.VisibleOBJBoundingBox.LBN.Z,pdwg.pcamera^.modelMatrix,ccsLBN,ccsRTF);
  ProjectPoint2(proot.VisibleOBJBoundingBox.RTF.x,proot.VisibleOBJBoundingBox.LBN.y,proot.VisibleOBJBoundingBox.LBN.Z,pdwg.pcamera^.modelMatrix,ccsLBN,ccsRTF);
  ProjectPoint2(proot.VisibleOBJBoundingBox.RTF.x,proot.VisibleOBJBoundingBox.RTF.y,proot.VisibleOBJBoundingBox.LBN.Z,pdwg.pcamera^.modelMatrix,ccsLBN,ccsRTF);
  ProjectPoint2(proot.VisibleOBJBoundingBox.LBN.x,proot.VisibleOBJBoundingBox.RTF.y,proot.VisibleOBJBoundingBox.LBN.Z,pdwg.pcamera^.modelMatrix,ccsLBN,ccsRTF);
  ProjectPoint2(proot.VisibleOBJBoundingBox.LBN.x,proot.VisibleOBJBoundingBox.LBN.y,proot.VisibleOBJBoundingBox.RTF.Z,pdwg.pcamera^.modelMatrix,ccsLBN,ccsRTF);
  ProjectPoint2(proot.VisibleOBJBoundingBox.RTF.x,proot.VisibleOBJBoundingBox.LBN.y,proot.VisibleOBJBoundingBox.RTF.Z,pdwg.pcamera^.modelMatrix,ccsLBN,ccsRTF);
  ProjectPoint2(proot.VisibleOBJBoundingBox.RTF.x,proot.VisibleOBJBoundingBox.RTF.y,proot.VisibleOBJBoundingBox.RTF.Z,pdwg.pcamera^.modelMatrix,ccsLBN,ccsRTF);
  ProjectPoint2(proot.VisibleOBJBoundingBox.LBN.x,proot.VisibleOBJBoundingBox.RTF.y,proot.VisibleOBJBoundingBox.RTF.Z,pdwg.pcamera^.modelMatrix,ccsLBN,ccsRTF);}

  tbb:=proot.vp.BoundingBox;

  if IsBBNul(tbb) then
  begin
       {tbb.LBN:=geometry.VertexAdd(pdwg.tpcamera^.prop.point,MinusOneVertex);
       tbb.RTF:=geometry.VertexAdd(pdwg.tpcamera^.prop.point,OneVertex);}
       concatBBandPoint(tbb,param.CSIcon.CSIconCoord);
       concatBBandPoint(tbb,param.CSIcon.CSIconX);
       concatBBandPoint(tbb,param.CSIcon.CSIconY);
       concatBBandPoint(tbb,param.CSIcon.CSIconZ);
  end;

  if pdwg.GetConstructObjRoot.ObjArray.Count>0 then
                       begin
  pdwg.GetConstructObjRoot.calcbb;
  tbb2:=pdwg.GetConstructObjRoot.vp.BoundingBox;
  ConcatBB(tbb,tbb2);
  end;
  {if param.CSIcon.AxisLen>eps then
  begin
  concatBBandPoint(tbb,param.CSIcon.CSIconCoord);
  concatBBandPoint(tbb,param.CSIcon.CSIconX);
  concatBBandPoint(tbb,param.CSIcon.CSIconY);
  concatBBandPoint(tbb,param.CSIcon.CSIconZ);
  end;}


  if IsBBNul(tbb) then
  begin
       tbb.LBN:=geometry.VertexAdd(pcamera^.prop.point,MinusOneVertex);
       tbb.RTF:=geometry.VertexAdd(pcamera^.prop.point,OneVertex);
  end;

  //if param.CSIcon.AxisLen>eps then
  begin
  //concatBBandPoint(tbb,param.CSIcon.CSIconCoord);
  //concatBBandPoint(tbb,param.CSIcon.CSIconX);
  //concatBBandPoint(tbb,param.CSIcon.CSIconY);
  //concatBBandPoint(tbb,param.CSIcon.CSIconZ);
  end;

  LBN:=tbb.LBN;
  RTF:=tbb.RTF;

  ProjectPoint2(LBN.x,LBN.y,LBN.Z,pcamera^.modelMatrix,ccsLBN,ccsRTF);
  ProjectPoint2(RTF.x,LBN.y,LBN.Z,pcamera^.modelMatrix,ccsLBN,ccsRTF);
  ProjectPoint2(RTF.x,RTF.y,LBN.Z,pcamera^.modelMatrix,ccsLBN,ccsRTF);
  ProjectPoint2(LBN.x,RTF.y,LBN.Z,pcamera^.modelMatrix,ccsLBN,ccsRTF);
  ProjectPoint2(LBN.x,LBN.y,RTF.Z,pcamera^.modelMatrix,ccsLBN,ccsRTF);
  ProjectPoint2(RTF.x,LBN.y,RTF.Z,pcamera^.modelMatrix,ccsLBN,ccsRTF);
  ProjectPoint2(RTF.x,RTF.y,RTF.Z,pcamera^.modelMatrix,ccsLBN,ccsRTF);
  ProjectPoint2(LBN.x,RTF.y,RTF.Z,pcamera^.modelMatrix,ccsLBN,ccsRTF);

  ccsLBN.z:=-ccsLBN.z;
  ccsRTF.z:=-ccsRTF.z;
  td:=(ccsRTF.z-ccsLBN.z)/20;
  td:=min(td,-ccsLBN.z/100);
  ccsLBN.z:=ccsLBN.z-td;
  ccsRTF.z:=ccsRTF.z+td;
  if (ccsLBN.z-ccsRTF.z)<sqreps then
                                 begin
                                      ccsLBN.z:=ccsLBN.z+1;
                                      ccsRTF.z:=ccsRTF.z-1;
                                 end;
  pcamera^.obj_zmAx:=ccsLBN.z;
  pcamera^.obj_zmin:=ccsRTF.z;
  pcamera^.zmax:=pcamera^.obj_zmAx;
  pcamera^.zmin:=pcamera^.obj_zmin;


  {if pdwg.pcamera^.zmax>10000 then
                                                pdwg.pcamera^.zmax:=100000;
  if pdwg.pcamera^.zmin<10000 then
                                                  pdwg.pcamera^.zmin:=-10000;}


  if param.projtype = PROJPerspective then
  begin
       if pcamera^.zmin<pcamera^.zmax/10000 then
                                                  pcamera^.zmin:=pcamera^.zmax/10000;
       if pcamera^.zmin<10 then
                                                  pcamera^.zmin:=10;
       if pcamera^.zmax<pcamera^.zmin then
                                                  pcamera^.zmax:=1000;
  end;



  if param.projtype = ProjParalel then
                                      begin
                                      pcamera^.projMatrix:=ortho(-getviewcontrol.clientwidth*pcamera^.prop.zoom/2,getviewcontrol.clientwidth*pcamera^.prop.zoom/2,
                                                                                 -getviewcontrol.clientheight*pcamera^.prop.zoom/2,getviewcontrol.clientheight*pcamera^.prop.zoom/2,
                                                                                 pcamera^.zmin, pcamera^.zmax,@onematrix);
                                      end
                                  else
                                      BEGIN
                                           pcamera^.projMatrix:=Perspective(pcamera^.fovy, getviewcontrol.Width / getviewcontrol.Height, pcamera^.zmin, pcamera^.zmax,@onematrix);
  //glGetDoublev(GL_PROJECTION_MATRIX, @pdwg.pcamera^.projMatrix);
                                      end;


  ///pdwg.pcamera.getfrustum(@pdwg.pcamera^.modelMatrix,   @pdwg.pcamera^.projMatrix,   pdwg.pcamera^.clip,   pdwg.pcamera^.frustum);



  pcamera^.CamCSOffset:=NulVertex;
  pcamera^.CamCSOffset.z:=(pcamera^.zmax+pcamera^.zmin)/2;
  pcamera^.CamCSOffset.z:=(pcamera^.zmin);


  tm:=pcamera^.modelMatrix;
  //MatrixInvert(tm);
  pcamera^.CamCSOffset:=geometry.VectorTransform3D(pcamera^.CamCSOffset,tm);
  pcamera^.CamCSOffset:=pcamera^.prop.point;

  {получение центра виевфрустума}
  tm:=geometry.CreateTranslationMatrix({minusvertex(pdwg.pcamera^.CamCSOffset)}nulvertex);

  //pdwg.pcamera^.modelMatrixLCS:=tm;
  pcamera^.modelMatrixLCS:=lookat({vertexsub(pdwg.pcamera^.prop.point,pdwg.pcamera^.CamCSOffset)}nulvertex,
                                               pcamera^.prop.xdir,
                                               pcamera^.prop.ydir,
                                               pcamera^.prop.look,{@tm}@onematrix);
  pcamera^.modelMatrixLCS:=geometry.MatrixMultiply(tm,pcamera^.modelMatrixLCS);
  ccsLBN:=InfinityVertex;
  ccsRTF:=MinusInfinityVertex;
  tbb:=proot.VisibleOBJBoundingBox;
  //pdwg.ConstructObjRoot.calcbb;
  tbb2:=pdwg.getConstructObjRoot.vp.BoundingBox;
  ConcatBB(tbb,tbb2);

  //proot.VisibleOBJBoundingBox:=tbb;

  if not IsBBNul(tbb) then
  begin
        LBN:=tbb.LBN;
        LBN:=vertexadd(LBN,pcamera^.CamCSOffset);
        RTF:=tbb.RTF;
        RTF:=vertexadd(RTF,pcamera^.CamCSOffset);
  end
  else
  begin
       LBN:=geometry.VertexMulOnSc(OneVertex,50);
       //LBN:=vertexadd(LBN,pdwg.pcamera^.CamCSOffset);
       RTF:=geometry.VertexMulOnSc(OneVertex,100);
       //RTF:=vertexadd(RTF,pdwg.pcamera^.CamCSOffset);
  end;
  ProjectPoint2(LBN.x,LBN.y,LBN.Z,pcamera^.modelMatrixLCS,ccsLBN,ccsRTF);
  ProjectPoint2(RTF.x,LBN.y,LBN.Z,pcamera^.modelMatrixLCS,ccsLBN,ccsRTF);
  ProjectPoint2(RTF.x,RTF.y,LBN.Z,pcamera^.modelMatrixLCS,ccsLBN,ccsRTF);
  ProjectPoint2(LBN.x,RTF.y,LBN.Z,pcamera^.modelMatrixLCS,ccsLBN,ccsRTF);
  ProjectPoint2(LBN.x,LBN.y,RTF.Z,pcamera^.modelMatrixLCS,ccsLBN,ccsRTF);
  ProjectPoint2(RTF.x,LBN.y,RTF.Z,pcamera^.modelMatrixLCS,ccsLBN,ccsRTF);
  ProjectPoint2(RTF.x,RTF.y,RTF.Z,pcamera^.modelMatrixLCS,ccsLBN,ccsRTF);
  ProjectPoint2(LBN.x,RTF.y,RTF.Z,pcamera^.modelMatrixLCS,ccsLBN,ccsRTF);
  ccsLBN.z:=-ccsLBN.z;
  ccsRTF.z:=-ccsRTF.z;
  td:=(ccsRTF.z-ccsLBN.z)/20;
  ccsLBN.z:=ccsLBN.z-td;
  ccsRTF.z:=ccsRTF.z+td;
  if (ccsLBN.z-ccsRTF.z)<sqreps then
                                 begin
                                      if abs(ccsLBN.z)>eps then
                                      begin
                                      ccsLBN.z:=ccsLBN.z/10;
                                      ccsRTF.z:=ccsRTF.z*10;
                                      end
                                      else
                                      begin
                                      ccsLBN.z:=+1;
                                      ccsRTF.z:=-1;
                                      end
                                 end;
  pcamera^.obj_zmAx:=ccsLBN.z;
  pcamera^.obj_zmin:=ccsRTF.z;
  pcamera^.zmaxLCS:=pcamera^.obj_zmAx;
  pcamera^.zminLCS:=pcamera^.obj_zmin;


  if param.projtype = PROJPerspective then
  begin
       if pcamera^.zminLCS<pcamera^.zmaxLCS/10000 then
                                                  pcamera^.zminLCS:=pcamera^.zmaxLCS/10000;
       if pcamera^.zminLCS<10 then
                                                  pcamera^.zminLCS:=10;
       if pcamera^.zmaxLCS<pcamera^.zminLCS then
                                                  pcamera^.zmaxLCS:=1000;
  end;

  pcamera^.zminLCS:=pcamera^.zminLCS;//-pdwg.pcamera^.CamCSOffset.z;
  pcamera^.zmaxLCS:=pcamera^.zmaxLCS;//+pdwg.pcamera^.CamCSOffset.z;

  //glLoadIdentity;
  //pdwg.pcamera^.projMatrix:=onematrix;
  if param.projtype = ProjParalel then
                                      begin
                                      pcamera^.projMatrixLCS:=ortho(-getviewcontrol.clientwidth*pcamera^.prop.zoom/2,getviewcontrol.clientwidth*pcamera^.prop.zoom/2,
                                                                                 -getviewcontrol.clientheight*pcamera^.prop.zoom/2,getviewcontrol.clientheight*pcamera^.prop.zoom/2,
                                                                                 pcamera^.zminLCS, pcamera^.zmaxLCS,@onematrix);
                                      end
                                  else
                                      BEGIN
                                           pcamera^.projMatrixLCS:=Perspective(pcamera^.fovy, getviewcontrol.Width / getviewcontrol.Height, pcamera^.zminLCS, pcamera^.zmaxLCS,@onematrix);
  //glGetDoublev(GL_PROJECTION_MATRIX, @pdwg.pcamera^.projMatrix);
                                      end;
  if param.projtype = ProjParalel then
                                      begin
                                           if geometry.oneVertexlength(pcamera^.CamCSOffset)>1000000 then
                                           begin
                                                CurrentCamCSOffset:=pcamera^.CamCSOffset;
                                                CurrentCamCSOffsetS:=VertexD2S(CurrentCamCSOffset);
                                                notuseLCS:=pcamera^.notuseLCS;
                                           end
                                           else notuseLCS:=true;
                                      end
                                  else
                                      begin
                                           notuseLCS:=true;
                                      end;
  if notuseLCS then
  begin
        pcamera^.projMatrixLCS:=pcamera^.projMatrix;
        pcamera^.modelMatrixLCS:=pcamera^.modelMatrix;
        pcamera^.frustumLCS:=pcamera^.frustum;
        pcamera^.CamCSOffset:=NulVertex;
        CurrentCamCSOffset:=nulvertex;
  end;


  if {pdwg.pcamera^.notuseLCS}notuseLCS then
  begin
        pcamera^.projMatrixLCS:=pcamera^.projMatrix;
        pcamera^.modelMatrixLCS:=pcamera^.modelMatrix;
        pcamera^.frustumLCS:=pcamera^.frustum;
        pcamera^.CamCSOffset:=NulVertex;
        CurrentCamCSOffset:=nulvertex;
  end;
  SetOGLMatrix;
  end;
    {$IFDEF PERFOMANCELOG}log.programlog.LogOutStrFast('TOGLWnd.CalcOptimalMatrix----{end}',lp_DecPos);{$ENDIF}
  //gdb.GetCurrentDWG.pcamera.getfrustum(@gdb.GetCurrentDWG.pcamera^.modelMatrixLCS,@gdb.GetCurrentDWG.pcamera^.projMatrixLCS,gdb.GetCurrentDWG.pcamera^.clipLCS,gdb.GetCurrentDWG.pcamera^.frustumLCS);
end;
procedure TGeneralViewArea.SetOGLMatrix;
var
    pcam:PGDBObjCamera;
begin
  {$IFDEF PERFOMANCELOG}log.programlog.LogOutStrFast('TOGLWnd.SetOGLMatrix',0);{$ENDIF}
  pcam:=pdwg.GetPcamera;
  pcam^.viewport[0]:=0;
  pcam^.viewport[1]:=0;
  pcam^.viewport[2]:=getviewcontrol.clientWidth;
  pcam^.viewport[3]:=getviewcontrol.clientHeight;
  drawer.SetOGLMatrix(pcam^,getviewcontrol.clientWidth, getviewcontrol.clientHeight);

  {oglsm.myglMatrixMode(GL_MODELVIEW);
  oglsm.myglLoadMatrixD(@pcam^.modelMatrixLCS);

  oglsm.myglMatrixMode(GL_PROJECTION);
  oglsm.myglLoadMatrixD(@pcam^.projMatrixLCS);

  oglsm.myglMatrixMode(GL_MODELVIEW);}


  pcam^.getfrustum(@pcam^.modelMatrix,   @pcam^.projMatrix,   pcam^.clip,   pdwg.GetPcamera^.frustum);
  pcam^.getfrustum(@pcam^.modelMatrixLCS,@pcam^.projMatrixLCS,pcam^.clipLCS,pdwg.GetPcamera^.frustumLCS);

end;
procedure TGeneralViewArea.PanScreen(oldX,oldY,X,Y:Integer);
var
  glmcoord1: gdbpiece;
  tv2:gdbvertex4d;
  ax:gdbvertex;
  //ux,uy:GDBDouble;
  //htext,htext2:gdbstring;
  //key: GDBByte;
  lptime:ttime;
begin
  mouseunproject(oldX, getviewcontrol.clientheight-oldY);
  glmcoord1:= param.md.mouseraywithoutos;
  mouseunproject(X, getviewcontrol.clientheight-Y);
  tv2.x:=(x - {param.md.mouse.x}oldX);
  tv2.y:=(y - {param.md.mouse.y}oldY);
  if (abs(tv2.x)>eps)or(abs(tv2.y)>eps) then
  begin
       ax.x:=-(param.md.mouseray.lend.x - glmcoord1.lend.x);
       ax.y:=(param.md.mouseray.lend.y - glmcoord1.lend.y);
       ax.z:=0;
       pdwg.MoveCameraInLocalCSXY(tv2.x,tv2.y,ax);
       {with gdb.GetCurrentDWG.UndoStack.PushCreateTGChangeCommand(gdb.GetCurrentDWG.pcamera^.prop)^ do
       begin
       gdb.GetCurrentDWG.pcamera.moveInLocalCSXY(tv2.x,tv2.y,ax);
       ComitFromObj;
       end;}
       param.firstdraw := true;
       pdwg.Getpcamera^.NextPosition;
       CalcOptimalMatrix;
       calcgrid;
       //gdb.GetCurrentDWG.Changed:=true;
       //-------------CalcOptimalMatrix;
       lptime:=now();
       pdwg.GetCurrentROOT.CalcVisibleByTree(pdwg.Getpcamera^.frustum,pdwg.Getpcamera.POSCOUNT,pdwg.Getpcamera.VISCOUNT,pdwg.GetCurrentROOT.ObjArray.ObjTree,pdwg.getpcamera.totalobj,pdwg.getpcamera.infrustum,pdwg.myGluProject2,pdwg.getpcamera.prop.zoom);
       lptime:=now()-LPTime;
       sysvar.RD.RD_LastCalcVisible:=round(lptime*10e7);
       //gdb.GetCurrentROOT.calcvisible(gdb.GetCurrentDWG.pcamera^.frustum,gdb.GetCurrentDWG.pcamera.POSCOUNT);
       pdwg.GetConstructObjRoot.calcvisible(pdwg.Getpcamera^.frustum,pdwg.Getpcamera.POSCOUNT,pdwg.Getpcamera.VISCOUNT,pdwg.getpcamera.totalobj,pdwg.getpcamera.infrustum,pdwg.myGluProject2,pdwg.getpcamera.prop.zoom);
  end;

end;

procedure TGeneralViewArea.projectaxis;
var
  i: GDBInteger;
  temp: gdbvertex;
  pv:pgdbvertex;
  tp:traceprop;

  Objects:GDBObjOpenArrayOfPV;
  pobj:pGDBObjEntity;
  ir:itrec;
begin
  PDWG.myGluProject2(param.ospoint.worldcoord,
             param.ospoint.dispcoord);
  if not sysvar.dwg.DWG_PolarMode^ then exit;
  //param.ospoint.arrayworldaxis.init({$IFDEF DEBUGBUILD}'{8BE71BAA-507B-4D6B-BE2C-63693022090C}',{$ENDIF}4);
  param.ospoint.arrayworldaxis.clear;
  pv:=polaraxis.PArray;
  for i:=0 to polaraxis.Count-1 do
  begin
       param.ospoint.arrayworldaxis.add(@pv^);
       inc(pv);
  end;
  //if param.ospoint.PGDBObject<>nil then
  begin
  objects.init({$IFDEF DEBUGBUILD}'{8BE71BAA-507B-4D6B-BE2C-63693022090C}',{$ENDIF}100);
  if PDWG.GetCurrentROOT.FindObjectsInPoint(param.ospoint.worldcoord,Objects) then
  begin
                       pobj:=objects.beginiterate(ir);
                       if pobj<>nil then
                       repeat
                             pgdbobjentity(pobj)^.AddOnTrackAxis(param.ospoint,addaxistootrack);
                             pobj:=objects.iterate(ir);
                       until pobj=nil;
  end;
  {if param.ospoint.PGDBObject<>nil then
  begin
       pgdbobjentity(param.ospoint.PGDBObject)^.AddOnTrackAxis(@param.ospoint);   fghfgh
  end;}
  objects.ClearAndDone;
  if param.processObjConstruct then
  begin
  objects.init({$IFDEF DEBUGBUILD}'{8BE71BAA-507B-4D6B-BE2C-63693022090C}',{$ENDIF}100);
  if PDWG.GetConstructObjRoot.FindObjectsInPointSlow(param.ospoint.worldcoord,Objects) then
  begin
                       pobj:=objects.beginiterate(ir);
                       if pobj<>nil then
                       repeat
                             pgdbobjentity(pobj)^.AddOnTrackAxis(param.ospoint,addaxistootrack);
                             pobj:=objects.iterate(ir);
                       until pobj=nil;
  end;
  objects.ClearAndDone;
  end;
  end;
  project0axis;
  {GDBGetMem(param.ospoint.arrayworldaxis, sizeof(GDBWord) + param.ppolaraxis^.count * sizeof(gdbvertex));
  Move(param.ppolaraxis^, param.ospoint.arrayworldaxis^, sizeof(GDBWord) + param.ppolaraxis^.count * sizeof(gdbvertex));}
  PDWG.myGluProject2(param.ospoint.worldcoord,
             param.ospoint.dispcoord);
  //param.ospoint.arraydispaxis.init({$IFDEF DEBUGBUILD}'{722A886F-5616-4E8F-B94D-3A1C3D7ADBD4}',{$ENDIF}param.ospoint.arrayworldaxis.count);
  param.ospoint.arraydispaxis.clear;
  //GDBGetMem(param.ospoint.arraydispaxis, sizeof(GDBWord) + param.ospoint.arrayworldaxis.count * sizeof(traceprop));
  //param.ospoint.arraydispaxis.count := param.ospoint.arrayworldaxis.count;
  pv:=param.ospoint.arrayworldaxis.PArray;
  for i := 0 to param.ospoint.arrayworldaxis.count - 1 do
  begin
    PDWG.myGluProject2(createvertex(param.ospoint.worldcoord.x + pv.x, param.ospoint.worldcoord.y + pv.y, param.ospoint.worldcoord.z + pv.z),
                                     temp);
    tp.dir.x:=temp.x - param.ospoint.dispcoord.x;
    tp.dir.y:=(temp.y - param.ospoint.dispcoord.y);
    tp.dir.z:=temp.z - param.ospoint.dispcoord.z;
    param.ospoint.arraydispaxis.add(@tp);
    {param.ospoint.arraydispaxis.arr[i].dir.x := temp.x - param.ospoint.dispcoord.x;
    param.ospoint.arraydispaxis.arr[i].dir.y := -(temp.y - param.ospoint.dispcoord.y);
    param.ospoint.arraydispaxis.arr[i].dir.z := temp.z - param.ospoint.dispcoord.z;}
    inc(pv);
  end
end;

procedure TGeneralViewArea.addaxistootrack(var posr:os_record;const axis:GDBVertex);
begin
     posr.arrayworldaxis.Add(@axis);

     if @posr<>@param.ontrackarray.otrackarray[0] then
     if (SysVar.dwg.DWG_OSMode^ and osm_paralel)<>0 then
     begin
          param.ontrackarray.otrackarray[0].arrayworldaxis.Add(@axis);
     end;
end;

procedure TGeneralViewArea.create0axis;
var
  i: GDBInteger;
  pv:pgdbvertex;
  Objects:GDBObjOpenArrayOfPV;
  pobj:pGDBObjEntity;
  ir:itrec;
begin
  PDWG.myGluProject2(param.ospoint.worldcoord,
             param.ospoint.dispcoord);
  if not assigned(sysvar.dwg.DWG_PolarMode) then exit;
  if not sysvar.dwg.DWG_PolarMode^ then exit;
  //param.ontrackarray.otrackarray[0].arrayworldaxis.init({$IFDEF DEBUGBUILD}'{8BE71BAA-507B-4D6B-BE2C-63693022090C}',{$ENDIF}4);
  param.ontrackarray.otrackarray[0].arrayworldaxis.clear;
  pv:=polaraxis.PArray;
  for i:=0 to polaraxis.Count-1 do
  begin
       param.ontrackarray.otrackarray[0].arrayworldaxis.add(@pv^);
       inc(pv);
  end;

  if tocommandmcliccount>0 then
  begin
  objects.init({$IFDEF DEBUGBUILD}'{8BE71BAA-507B-4D6B-BE2C-63693022090C}',{$ENDIF}100);
  if PDWG.GetCurrentROOT.FindObjectsInPoint(param.ontrackarray.otrackarray[0].worldcoord,Objects) then
  begin
                       pobj:=objects.beginiterate(ir);
                       if pobj<>nil then
                       repeat
                             pgdbobjentity(pobj)^.AddOnTrackAxis(param.ontrackarray.otrackarray[0],addaxistootrack);
                             pobj:=objects.iterate(ir);
                       until pobj=nil;
  end;
  objects.ClearAndDone;
                       if param.processObjConstruct then
                       begin
  objects.init({$IFDEF DEBUGBUILD}'{8BE71BAA-507B-4D6B-BE2C-63693022090C}',{$ENDIF}100);
  if PDWG.GetConstructObjRoot.FindObjectsInPointSlow(param.ontrackarray.otrackarray[0].worldcoord,Objects) then
  begin
                       pobj:=objects.beginiterate(ir);
                       if pobj<>nil then
                       repeat
                             pgdbobjentity(pobj)^.AddOnTrackAxis(param.ontrackarray.otrackarray[0],addaxistootrack);
                             pobj:=objects.iterate(ir);
                       until pobj=nil;
  end;
  objects.ClearAndDone;
  end;
  end;


  Project0Axis;
end;

procedure TGeneralViewArea.Project0Axis;
var
  tp: traceprop;
  temp: gdbvertex;
  pv: pgdbvertex;
  i: GDBInteger;
begin
  {GDBGetMem(param.ospoint.arrayworldaxis, sizeof(GDBWord) + param.ppolaraxis
    ^.count * sizeof(gdbvertex));
  Move(param.ppolaraxis^, param.ospoint.arrayworldaxis^, sizeof(GDBWord) +
    param.ppolaraxis^.count * sizeof(gdbvertex)); }
  {gdb.GetCurrentDWG^}pdwg.myGluProject2(param.ontrackarray.otrackarray[0
    ].worldcoord,
             param.ontrackarray.otrackarray[0].dispcoord);
  //param.ontrackarray.otrackarray[0].arraydispaxis.init({$IFDEF DEBUGBUILD}'{722A886F-5616-4E8F-B94D-3A1C3D7ADBD4}', {$ENDIF}    param.ontrackarray.otrackarray[0].arrayworldaxis.count);
  param.ontrackarray.otrackarray[0].arraydispaxis.clear;
  //GDBGetMem(param.ospoint.arraydispaxis, sizeof(GDBWord) +param.ospoint.arrayworldaxis.count * sizeof(traceprop));
  //param.ospoint.arraydispaxis.count := param.ospoint.arrayworldaxis.count;
  pv:=param.ontrackarray.otrackarray[0].arrayworldaxis.PArray;
  for i := 0 to param.ontrackarray.otrackarray[0].arrayworldaxis.count - 1 do
  begin
    {gdb.GetCurrentDWG^}pdwg.myGluProject2(createvertex(param.ontrackarray.otrackarray
      [0].worldcoord.x + pv.x, param.ontrackarray.otrackarray[0].worldcoord.y +
      pv.y, param.ontrackarray.otrackarray[0].worldcoord.z + pv.z)
                                    , temp);
    tp.dir.x:=temp.x - param.ontrackarray.otrackarray[0].dispcoord.x;
    tp.dir.y:=(temp.y - param.ontrackarray.otrackarray[0].dispcoord.y);
    tp.dir.z:=temp.z - param.ontrackarray.otrackarray[0].dispcoord.z;
    param.ontrackarray.otrackarray[0].arraydispaxis.add(@tp);
    {param.ospoint.arraydispaxis.arr[i].dir.x := temp.x -
      param.ospoint.dispcoord.x;
    param.ospoint.arraydispaxis.arr[i].dir.y := -(temp.y -
      param.ospoint.dispcoord.y);
    param.ospoint.arraydispaxis.arr[i].dir.z := temp.z -
      param.ospoint.dispcoord.z; }
    inc(pv);
  end
end;

procedure TGeneralViewArea.reprojectaxis;
var
  i, j, a: GDBInteger;
  temp: gdbvertex;
  pv:pgdbvertex;
  pt,pt2:ptraceprop;
  ir,ir2:itrec;
  ip:intercept3dprop;
  lastontracdist,currentontracdist,tx,ty,tz:gdbdouble;
  test:gdbboolean;
  pobj:pgdbobjentity;
//  dispraylen:double;
begin
  if param.ontrackarray.total = 0 then exit;
  param.polarlinetrace := 0;

    if tocommandmcliccount=0 then
                                 a:=1
                             else
                                 a:=0;
    for j := a to param.ontrackarray.total - 1 do
    begin
      PDWG.myGluProject2(param.ontrackarray.otrackarray[j].worldcoord,
                 param.ontrackarray.otrackarray[j].dispcoord);
    end;
    if not assigned(sysvar.dwg.DWG_PolarMode) then exit;
    if not sysvar.dwg.DWG_PolarMode^ then exit;
  for j := a to param.ontrackarray.total - 1 do
  begin
    {gdb.GetCurrentDWG^.myGluProject2(param.ontrackarray.otrackarray[j].worldcoord,
               param.ontrackarray.otrackarray[j].dispcoord);}
    param.ontrackarray.otrackarray[j].dispcoord.z:=0;
    param.ontrackarray.otrackarray[j].dmousecoord.x :=
    param.md.glmouse.x - param.ontrackarray.otrackarray[j].dispcoord.x;
    param.ontrackarray.otrackarray[j].dmousecoord.y :=
    //-(clientheight - param.md.glmouse.y - param.ontrackarray.otrackarray[j].dispcoord.y);
    param.md.glmouse.y -  param.ontrackarray.otrackarray[j].dispcoord.y;
    param.ontrackarray.otrackarray[j].dmousecoord.z := 0;
     //caption:=floattostr(ontrackarray.otrackarray[j].dmousecoord.x)+';'+floattostr(ontrackarray.otrackarray[j].dmousecoord.y);
     //caption:='' ;
    param.ontrackarray.otrackarray[j].dmousecoord.z := 0;
    lastontracdist:=infinity;
    pt2:=nil;
    if param.ontrackarray.otrackarray[j].arrayworldaxis.Count <> 0 then
    begin
      pv:=param.ontrackarray.otrackarray[j].arrayworldaxis.PArray;
      pt:=param.ontrackarray.otrackarray[j].arraydispaxis.PArray;
      for i := 0 to param.ontrackarray.otrackarray[j].arrayworldaxis.count - 1 do
      begin
        PDWG.myGluProject2(createvertex(param.ontrackarray.otrackarray[j].worldcoord.x + pv.x,
                   param.ontrackarray.otrackarray[j].worldcoord.y + pv.y,
                   param.ontrackarray.otrackarray[j].worldcoord.z + pv.z),
                   temp);
        pt.dir.x := temp.x - param.ontrackarray.otrackarray[j].dispcoord.x;
        pt.dir.y := (temp.y - param.ontrackarray.otrackarray[j].dispcoord.y);
        pt.dir.z := temp.z - param.ontrackarray.otrackarray[j].dispcoord.z;

        pt.trace:=false;

        if (pt.dir.x*pt.dir.x+pt.dir.y*pt.dir.y)>sqreps then

        begin
        pt.tmouse :=
          (pt.dir.x *
          param.ontrackarray.otrackarray[j].dmousecoord.x +
          pt.dir.y *
          param.ontrackarray.otrackarray[j].dmousecoord.y)
          / (sqr(pt.dir.x) + sqr(pt.dir.y));
        //dispraylen:=

        tx:=pt.tmouse * pv.x;
        ty:=pt.tmouse * pv.y;
        tz:=pt.tmouse * pv.z;

        pt.dispraycoord.x := param.ontrackarray.otrackarray[j].dispcoord.x + pt.tmouse * pt.dir.x;
        pt.dispraycoord.y := param.ontrackarray.otrackarray[j].dispcoord.y + pt.tmouse * pt.dir.y;
        pt.dispraycoord.z:=0;
        pt.worldraycoord.x := param.ontrackarray.otrackarray[j].worldcoord.x + {pt.tmouse * pv.x}tx;
        pt.worldraycoord.y := param.ontrackarray.otrackarray[j].worldcoord.y + {pt.tmouse * pv.y}ty;
        pt.worldraycoord.z := param.ontrackarray.otrackarray[j].worldcoord.z + {pt.tmouse * pv.z}tz;
          //temp.x:=ontrackarray.otrackarray[j].dmousecoord.x-ontrackarray.otrackarray[j].arraydispaxis.arr[i].dispraycoord.x;
          //temp.y:=ontrackarray.otrackarray[j].dmousecoord.y-ontrackarray.otrackarray[j].arraydispaxis.arr[i].dispraycoord.y;
        temp.x := param.md.glmouse.x - pt.dispraycoord.x;
        temp.y := param.md.glmouse.y - pt.dispraycoord.y {clientheight - param.md.glmouse.y - pt.dispraycoord.y};




        pt.dmouse := round(sqrt(temp.x * temp.x + temp.y * temp.y));
        pt.trace:=false;
        if pt.dmouse < ontracdist then
        begin
        //currentontracdist:=pt.dmouse;
        if (pt.dmouse<lastontracdist) then
        if (param.ospoint.ostype=os_blockinsert)or(param.ospoint.ostype=os_insert)or(param.ospoint.ostype=os_textinsert)or(param.ospoint.ostype=os_none)or(param.ospoint.ostype={os_intersection}os_trace) then
        begin
        if geometry.vertexlen2df(param.ontrackarray.otrackarray[j].dispcoord.x,
                                 param.ontrackarray.otrackarray[j].dispcoord.y,
                                 param.md.glmouse.x,
                                 param.md.glmouse.y)>ontracignoredist then

        begin
          if param.polarlinetrace=0 then
                                        test:=true
                                    else
                                        test:=false;
          if not(test) then
                           begin
                                if not geometry.vertexeq(pt.worldraycoord,param.ospoint.worldcoord)
                                then test:=true;
                           end;
          if test then

          begin
          lastontracdist:=pt.dmouse;
          if pt2<>nil then
                          pt2.trace:=false;
          pt2:=pt;
          pt.trace:=true;
          param.ospoint.worldcoord := pt.worldraycoord;
          param.ospoint.dispcoord := pt.dispraycoord;
          param.ospoint.ostype := {os_polar}{os_midle}{os_intersection}os_trace;
          param.pointnum := j;
          param.axisnum := i;
          //param.ospoint.tmouse:=pt.dmouse;
          inc(param.polarlinetrace);

          param.ontrackarray.otrackarray[j].tmouse:=sqrt(tx*tx+ty*ty+tz*tz);
          end;
        end;
        end;
        end;
        end;
        inc(pt);
        inc(pv);
      end;
   end;
  end;

  lastontracdist:=infinity;
  if param.polarlinetrace>0 then
  for i := a to param.ontrackarray.total - 1 do
  begin
       pt:=param.ontrackarray.otrackarray[i].arraydispaxis.beginiterate(ir2);
       if pt<>nil then
       begin
       repeat
            if pt^.trace then
            begin
            pobj:=PDWG.GetOnMouseObj.beginiterate(ir);
            if pobj<>nil then
            repeat
                  ip:=pobj.IsIntersect_Line(param.ontrackarray.otrackarray[i].worldcoord,pt.worldraycoord);

                  if ip.isintercept then
                  begin
                   PDWG.myGluProject2(ip.interceptcoord,temp);
                  currentontracdist:=vertexlen2df(temp.x, temp.y,param.md.glmouse.x,param.md.glmouse.y);
                  if currentontracdist<lastontracdist then
                  //if currentontracdist<sysvar.DISP.DISP_CursorSize^*sysvar.DISP.DISP_CursorSize^+1 then
                  begin
                  param.ospoint.worldcoord := ip.interceptcoord;
                  param.ospoint.dispcoord := temp;
                  param.ospoint.ostype := {os_polar}os_apparentintersection;
                  lastontracdist:=currentontracdist;
                  end;
                  end;



                  pobj:=PDWG.GetOnMouseObj.iterate(ir);
            until pobj=nil;
            end;
            pt:=param.ontrackarray.otrackarray[i].arraydispaxis.iterate(ir2);
      until pt=nil;
       end;
  end;



  if param.polarlinetrace<2 then exit;
    //lastontracdist:=infinity;

  for i := a to param.ontrackarray.total - 1 do
  for j := i+1 to param.ontrackarray.total - 1 do
  begin
       pt:=param.ontrackarray.otrackarray[i].arraydispaxis.beginiterate(ir);
       if pt<>nil then
       repeat
                     lastontracdist:=infinity;
                     pt2:=param.ontrackarray.otrackarray[j].arraydispaxis.beginiterate(ir2);
                     if pt2<>nil then
                     repeat
                           if (pt.trace)and(pt2.trace) then
                           if SqrOneVertexlength(vectordot(pt.dir,pt2.dir))>sqreps then
                           begin
                           ip:=ip;
                           ip.isintercept:=false;
                           ip:=intercept3dmy2(param.ontrackarray.otrackarray[i].worldcoord,pt.worldraycoord,param.ontrackarray.otrackarray[j].worldcoord,pt2.worldraycoord);
                           //ip:=intercept3dmy(createvertex(0,0,0),createvertex(0,2,0),createvertex(-1,1,0),createvertex(1,1,0));
                                    begin
                                      if ip.isintercept then
                                      begin
                                      PDWG.myGluProject2(ip.interceptcoord,
                                                                       temp);

                                      currentontracdist:=vertexlen2df(temp.x, temp.y,param.md.glmouse.x,param.md.glmouse.y);
                                      if currentontracdist<lastontracdist then
                                      if currentontracdist<sysvar.DISP.DISP_CursorSize^*sysvar.DISP.DISP_CursorSize^+1 then
                                      begin
                                      param.ospoint.worldcoord := ip.interceptcoord;
                                      param.ospoint.dispcoord := temp;
                                      param.ospoint.ostype := {os_polar}os_apparentintersection;
                                      lastontracdist:=currentontracdist;
                                      end;
                                      end;
                                      //param.pointnum := j;
                                      //param.axisnum := i;
                                      //inc(param.polarlinetrace);
                                    end;

                           end;

                           pt2:=param.ontrackarray.otrackarray[j].arraydispaxis.iterate(ir2);
                     until pt2=nil;



             pt:=param.ontrackarray.otrackarray[i].arraydispaxis.iterate(ir);
       until pt=nil;

  end;
end;
procedure TGeneralViewArea.myKeyPress(var Key: Word; Shift: TShiftState);
{$IFDEF DELPHI}
const
     VK_V=$56;
{$ENDIF}
begin
      if Key=VK_ESCAPE then
      begin
        if assigned(ReStoreGDBObjInspProc)then
        begin
        if not ReStoreGDBObjInspProc then
        begin
        ClearOntrackpoint;
        if commandmanager.pcommandrunning=nil then
          begin
          PDWG.GetCurrentROOT.ObjArray.DeSelect(PDWG^.GetSelObjArray,param.SelDesc.Selectedobjcount);
          param.SelDesc.LastSelectedObject := nil;
          param.SelDesc.OnMouseObject := nil;
          param.seldesc.Selectedobjcount:=0;
          param.firstdraw := TRUE;
          PDWG.GetSelObjArray.clearallobjects;
          CalcOptimalMatrix;
          paint;
          if assigned(SetVisuaProplProc) then SetVisuaProplProc;
          setobjinsp;
          end
        else
          begin
               commandmanager.pcommandrunning.CommandCancel;
               commandmanager.executecommandend;
          end;
        end;
        end;
        Key:=0;
      end
 {else if (Key = VK_A) and (shift=[ssCtrl]) then
      begin
        commandmanager.ExecuteCommand('SelectAll');
        Key:=00;
      end}
 {else if (Key = VK_Z) and (shift=[ssCtrl]) then
      begin
        commandmanager.ExecuteCommand('Undo');
        Key:=00;
      end}
  {else if (Key = VK_Z) and (shift=[ssCtrl,ssShift]) then
      begin
        commandmanager.ExecuteCommand('Redo');
        Key:=00;
      end}
 {else if (Key = VK_DELETE) then
      begin
        commandmanager.ExecuteCommand('Erase');
        Key:=00;
      end}
 else if (Key = VK_RETURN)or(Key = VK_SPACE) then
      begin
           commandmanager.executelastcommad(pdwg,@param);
           Key:=00;
      end
 else if (Key=VK_V)and(shift=[ssctrl]) then
                    begin
                         commandmanager.executecommand('PasteClip',pdwg,@param);
                         key:=00;
                    end
 (*else if (Key=VK_TAB)and(shift=[ssctrl,ssShift]) then
                          begin
                               //if assigned(MainFormN.PageControl)then
                               //   if MainFormN.PageControl.PageCount>1 then
                                  begin
                                       commandmanager.executecommandsilent('PrevDrawing');
                                       key:=00;
                                  end;
                          end
 else if (Key=VK_TAB)and(shift=[ssctrl]) then
                          begin
                               //if assigned(MainFormN.PageControl)then
                               //   if MainFormN.PageControl.PageCount>1 then
                                  begin
                                       commandmanager.executecommandsilent('NextDrawing');
                                       key:=00;
                                  end;
                          end*)
end;

function TGeneralViewArea.ProjectPoint(pntx,pnty,pntz:gdbdouble;var wcsLBN,wcsRTF,dcsLBN,dcsRTF: GDBVertex):gdbvertex;
begin
     PDWG.myGluProject2(CreateVertex(pntx,pnty,pntz),
     result);


     if result.x<dcsLBN.x then
                              begin
                                   dcsLBN.x:=result.x;
                                   wcsLBN.x:=pntx;
                              end;
     if result.y<dcsLBN.y then
                              begin
                                   dcsLBN.y:=result.y;
                                   wcsLBN.y:=pnty;
                              end;
     if result.z<dcsLBN.z then
                              begin
                                   dcsLBN.z:=result.z;
                                   wcsLBN.z:=pntz;
                              end;
     if result.x>dcsRTF.x then
                              begin
                                   dcsRTF.x:=result.x;
                                   wcsRTF.x:=pntx;
                              end;
     if result.y>dcsRTF.y then
                              begin
                                   dcsRTF.y:=result.y;
                                   wcsRTF.y:=pnty;
                              end;
     if result.z>dcsRTF.z then
                              begin
                                   dcsRTF.z:=result.z;
                                   wcsRTF.z:=pntz;
                              end;
end;
procedure TGeneralViewArea.mouseunproject(X, Y: integer);
var ca, cv: extended; ds:GDBString;
begin
  if pdwg=NIL then exit;

  pdwg^.myGluUnProject(createvertex(x, y, 0),param.md.mouseray.lbegin);
  pdwg^.myGluUnProject(createvertex(x, y, 1),param.md.mouseray.lend);

  param.md.mouseray.dir:=vertexsub(param.md.mouseray.lend,param.md.mouseray.lbegin);
  cv:=param.md.workplane[0]*param.md.mouseray.dir.x +
      param.md.workplane[1]*param.md.mouseray.dir.y +
      param.md.workplane[2]*param.md.mouseray.dir.z;
  ca:=-param.md.workplane[3] - param.md.workplane[0]*param.md.mouseray.lbegin.x -
       param.md.workplane[1]*param.md.mouseray.lbegin.y -
       param.md.workplane[2]*param.md.mouseray.lbegin.z;
  if cv = 0 then param.md.mouseonworkplan := false
  else begin
    param.md.mouseonworkplan := true;
    ca := ca / cv;
    param.md.mouseonworkplanecoord.x := param.md.mouseray.lbegin.x + param.md.mouseray.dir.x * ca;
    param.md.mouseonworkplanecoord.y := param.md.mouseray.lbegin.y + param.md.mouseray.dir.y * ca;
    param.md.mouseonworkplanecoord.z := param.md.mouseray.lbegin.z + param.md.mouseray.dir.z * ca;

    ca:=param.md.workplane[0] * param.md.mouseonworkplanecoord.x +
        param.md.workplane[1] * param.md.mouseonworkplanecoord.y +
        param.md.workplane[2] * param.md.mouseonworkplanecoord.z+param.md.workplane[3];

    if ca<>0 then
    begin
         param.md.mouseonworkplanecoord.x:=param.md.mouseonworkplanecoord.x-param.md.workplane[0]*ca;
         param.md.mouseonworkplanecoord.y:=param.md.mouseonworkplanecoord.y-param.md.workplane[1]*ca;
         param.md.mouseonworkplanecoord.z:=param.md.mouseonworkplanecoord.z-param.md.workplane[2]*ca;
    end;
    ca:=param.md.workplane[0] * param.md.mouseonworkplanecoord.x +
        param.md.workplane[1] * param.md.mouseonworkplanecoord.y +
        param.md.workplane[2] * param.md.mouseonworkplanecoord.z + param.md.workplane[3];
    str(ca,ds);
  end;
end;
procedure TGeneralViewArea.SetMouseMode(smode:GDBByte);
begin
     param.md.mode := smode;
end;
procedure TGeneralViewArea.ClearOntrackpoint;
begin
  param.ontrackarray.current := 1;
  param.ontrackarray.total := 1;
end;
procedure TGeneralViewArea.Clear0Ontrackpoint;
begin
  param.ontrackarray.current := 1;
  param.ontrackarray.total := 1;
  tocommandmcliccount:=0;
end;
procedure TGeneralViewArea.calcgrid;
var
    tempv,cav: gdbvertex;
    l,u,r,b,maxh,maxv,ph,pv:GDBDouble;
begin
     if pdwg=NIL then exit;
     tempv.x:=0;
     tempv.y:=0;
     tempv.z:=0;
     pdwg^.myGluUnProject(tempv,cav);
     param.BLPoint.x:=cav.x;
     param.BLPoint.y:=cav.y;

     tempv.x:=getviewcontrol.clientwidth/2;
     tempv.y:=getviewcontrol.clientheight/2;
     tempv.z:=0;
     pdwg^.myGluUnProject(tempv,cav);
     param.CPoint.x:=cav.x;
     param.CPoint.y:=cav.y;

     tempv.x:=getviewcontrol.clientwidth;
     tempv.y:=getviewcontrol.clientheight;
     tempv.z:=0;
     pdwg^.myGluUnProject(tempv,cav);
     param.TRPoint.x:=cav.x;
     param.TRPoint.y:=cav.y;

     tempv.x:=0;
     tempv.y:=getviewcontrol.clientheight;
     tempv.z:=0;
     pdwg^.myGluUnProject(tempv,cav);
     param.ViewHeight:=cav.y-param.BLPoint.y;


     pdwg^.myGluProject2(NulVertex,param.CSIcon.CSIconCoord);

     if (param.CSIcon.CSIconCoord.x>0)and(param.CSIcon.CSIconCoord.y>0)and(param.CSIcon.CSIconCoord.x<getviewcontrol.clientwidth)and(param.CSIcon.CSIconCoord.y<getviewcontrol.clientheight)
     then
     begin
          pdwg^.myGluProject2(x_Y_zVertex,
                                  cav);
          cav.x:=param.CSIcon.CSIconCoord.x-cav.x;
          cav.y:=param.CSIcon.CSIconCoord.y-cav.y;
          param.CSIcon.axislen:=sqrt(cav.x*cav.x+cav.y*cav.y);
          param.CSIcon.CSIconCoord.x:=0;
          param.CSIcon.CSIconCoord.y:=0;
          param.CSIcon.CSIconCoord.z:=0;
     end
     else
     begin
     pdwg^.myGluUnProject(createvertex(40, 40, 0.1),
                                 param.CSIcon.CSIconCoord);
          pdwg^.myGluProject2(CreateVertex(param.CSIcon.CSIconCoord.x,param.CSIcon.CSIconCoord.y+1,param.CSIcon.CSIconCoord.z),

                     cav);
          cav.x:=40-cav.x;
          cav.y:=40-cav.y;
          param.CSIcon.axislen:=sqrt(cav.x*cav.x+cav.y*cav.y);

     end;
     if param.CSIcon.axislen>eps then
                                     param.CSIcon.axislen:=100/param.CSIcon.axislen;
     param.CSIcon.CSIconX:=param.CSIcon.CSIconCoord;
     param.CSIcon.CSIconX.x:=param.CSIcon.CSIconX.x+param.CSIcon.axislen;
     param.CSIcon.CSIconY:=param.CSIcon.CSIconCoord;
     param.CSIcon.CSIconY.y:=param.CSIcon.CSIconY.y+param.CSIcon.axislen;
     param.CSIcon.CSIconZ:=param.CSIcon.CSIconCoord;
     param.CSIcon.CSIconZ.z:=param.CSIcon.CSIconZ.z+param.CSIcon.axislen;


     pdwg^.myGluProject2(CreateVertex(param.CSIcon.CSIconCoord.x + sizeaxis * pdwg.getpcamera^.prop.zoom, param.CSIcon.CSIconCoord.y, param.CSIcon.CSIconCoord.z),
                CAV);
     param.CSIcon.csx.x := round(cav.x);
     param.CSIcon.csx.y := round(cav.y);
     pdwg^.myGluProject2(CreateVertex(param.CSIcon.CSIconCoord.x, param.CSIcon.CSIconCoord.y + sizeaxis * pdwg.getpcamera^.prop.zoom, param.CSIcon.CSIconCoord.z),
                CAV);
     param.CSIcon.csy.x := round(cav.x);
     param.CSIcon.csy.y := round(cav.y);
     pdwg^.myGluProject2(CreateVertex(param.CSIcon.CSIconCoord.x, param.CSIcon.CSIconCoord.y, param.CSIcon.CSIconCoord.z + sizeaxis * pdwg.getpcamera^.prop.zoom),
                CAV);
     param.CSIcon.csz.x := round(cav.x);
     param.CSIcon.csz.y := round(cav.y);

     param.md.WPPointLU:=PointOf3PlaneIntersect(pdwg.getpcamera.frustum[0],pdwg.getpcamera.frustum[3],param.md.workplane);
     param.md.WPPointUR:=PointOf3PlaneIntersect(pdwg.getpcamera.frustum[3],pdwg.getpcamera.frustum[1],param.md.workplane);
     param.md.WPPointRB:=PointOf3PlaneIntersect(pdwg.getpcamera.frustum[1],pdwg.getpcamera.frustum[2],param.md.workplane);
     param.md.WPPointBL:=PointOf3PlaneIntersect(pdwg.getpcamera.frustum[2],pdwg.getpcamera.frustum[0],param.md.workplane);
     l:=Vertexlength(param.md.WPPointLU,param.md.WPPointBL);
     r:=Vertexlength(param.md.WPPointUR,param.md.WPPointRB);
     u:=Vertexlength(param.md.WPPointLU,param.md.WPPointUR);
     b:=Vertexlength(param.md.WPPointRB,param.md.WPPointBL);
     if r>l then
                maxh:=r
            else
                maxh:=l;
     if b>u then
                maxv:=b
            else
                maxv:=u;
     ph:=(maxh/sysvar.DWG.DWG_GridSpacing.y)+1;
     pv:=(maxv/sysvar.DWG.DWG_GridSpacing.x)+1;
     param.md.WPPointUR.z:=1;
     if (4*ph>getviewcontrol.clientwidth)or(4*pv>getviewcontrol.clientheight)then
                                                   begin
                                                        if sysvar.DWG.DWG_DrawGrid<>nil then
                                                        if sysvar.DWG.DWG_DrawGrid^ then
                                                                                        historyoutstr(rsGridTooDensity);
                                                        param.md.WPPointUR.z:=-1;
                                                   end;
     param.md.WPPointLU:=vertexmulonsc(vertexsub(param.md.WPPointLU,param.md.WPPointBL),1/pv);
     param.md.WPPointRB:=vertexmulonsc(vertexsub(param.md.WPPointRB,param.md.WPPointBL),1/ph);

     param.md.WPPointBL.x:=round((param.md.WPPointBL.x-SysVar.DWG.DWG_Snap.Base.x)/SysVar.DWG.DWG_GridSpacing.x)*SysVar.DWG.DWG_GridSpacing.x+SysVar.DWG.DWG_GridSpacing.x+SysVar.DWG.DWG_Snap.Base.x;
     param.md.WPPointBL.y:=round((param.md.WPPointBL.y-SysVar.DWG.DWG_Snap.Base.y)/SysVar.DWG.DWG_GridSpacing.y)*SysVar.DWG.DWG_GridSpacing.y-SysVar.DWG.DWG_GridSpacing.y+SysVar.DWG.DWG_Snap.Base.y;

     param.md.WPPointBL.z:=(-param.md.workplane[3]-param.md.workplane[0]*param.md.WPPointBL.x-param.md.workplane[1]*param.md.WPPointBL.y)/param.md.workplane[2];

     param.md.WPPointUR.x:=pv;
     param.md.WPPointUR.y:=ph;
end;
procedure TGeneralViewArea.SetObjInsp;
begin
     if assigned(OnSetObjInsp)then
                                  OnSetObjInsp(self);
end;

begin
  {$IFDEF DEBUGINITSECTION}LogOut('viewareadef.initialization');{$ENDIF}
end.
