;
; These files are loaded by default in NCL V6.2.0 and newer
; load "$NCARG_ROOT/lib/ncarg/nclscripts/csm/gsn_code.ncl"
; load "$NCARG_ROOT/lib/ncarg/nclscripts/csm/gsn_csm.ncl"
;**************************************************
begin
;**************************************************

windspeed = new((/200000000/),"float")
omega     = new((/200000000/),"float")

windspeed(:) = 1e20
omega(:) = 1e20

year = ispan(1979,2022,1)
;year = ispan(2012,2012,1)
;year = ispan(1979,1979,1)

count = 0
count2 = 0

multi_grid = 2
final = new((/40*multi_grid+1,20*multi_grid+1/),"float")
final(:,:) = 0.

;print(dimsizes(final))

final_y = new((/40*multi_grid+1/),"float")
final_y(:) = 0.
final_x = new((/20*multi_grid+1/),"float")
final_x(:) = 0.

do nyr=0, dimsizes(year)-1

;level = 1000, 975, 850, 950, 900, 875, 850, 825, 800, 775, 750, 700, 650, 600, 550, 500, 450, 400, 350, 300, 250, 225, 200, 150 ;
;f_u = addfile("/mnt/lustre/proj/jhson/SJ/era5/data/Atlantic3_0.25/Atlantic3_pl_u_975_"+year(nyr)+".nc","r")
;u = short2flt(f_u->u)  ;to apply add_offset and scale_factor
;f_v = addfile("/mnt/lustre/proj/jhson/SJ/era5/data/Atlantic3_0.25/Atlantic3_pl_v_975_"+year(nyr)+".nc","r")
;v = short2flt(f_v->v)  ;to apply add_offset and scale_factor

f_w = addfile("/mnt/lustre/proj/jhson/SJ/era5/data/Atlantic3_0.25/Atlantic3_pl_w_950_"+year(nyr)+".nc","r")
;w = f_t->w
w = short2flt(f_w->w)  ;to apply add_offset and scale_factor
lon = f_w->longitude
lat = f_w->latitude
ttt = f_w->time

f_t = addfile("/mnt/lustre/proj/jhson/SJ/era5/data/Atlantic3_0.25/Atlantic3_storm_tracking_"+year(nyr)+".nc","r")
storm_track = f_t->storm_track
;storm_track=[number,time,information]
;[0:number, 1:hgt, 2:longitude, 3:latitude, 4:timedimension, 5:duration, 6:year, 7:month, 8:day, 9:hour]

;print(dimsizes(w))
nx = dimsizes(lon)
ny = dimsizes(lat)
nt = dimsizes(ttt)
dim = dimsizes(storm_track)
;print(dim)

f_u = addfile("/mnt/lustre/proj/jhson/SJ/era5/data/Atlantic3_0.25/sfc/Atlantic_sfc_10u_"+year(nyr)+"_01.nc","r")
u10_1 = short2flt(f_u->u10)  ;to apply add_offset and scale_factor
f_v = addfile("/mnt/lustre/proj/jhson/SJ/era5/data/Atlantic3_0.25/sfc/Atlantic_sfc_10v_"+year(nyr)+"_01.nc","r")
v10_1 = short2flt(f_v->v10)  ;to apply add_offset and scale_factor

f_u = addfile("/mnt/lustre/proj/jhson/SJ/era5/data/Atlantic3_0.25/sfc/Atlantic_sfc_10u_"+year(nyr)+"_02.nc","r")
u10_2 = short2flt(f_u->u10)  ;to apply add_offset and scale_factor
f_v = addfile("/mnt/lustre/proj/jhson/SJ/era5/data/Atlantic3_0.25/sfc/Atlantic_sfc_10v_"+year(nyr)+"_02.nc","r")
v10_2 = short2flt(f_v->v10)  ;to apply add_offset and scale_factor

f_u = addfile("/mnt/lustre/proj/jhson/SJ/era5/data/Atlantic3_0.25/sfc/Atlantic_sfc_10u_"+year(nyr)+"_10.nc","r")
u10_10 = short2flt(f_u->u10)  ;to apply add_offset and scale_factor
f_v = addfile("/mnt/lustre/proj/jhson/SJ/era5/data/Atlantic3_0.25/sfc/Atlantic_sfc_10v_"+year(nyr)+"_10.nc","r")
v10_10 = short2flt(f_v->v10)  ;to apply add_offset and scale_factor

f_u = addfile("/mnt/lustre/proj/jhson/SJ/era5/data/Atlantic3_0.25/sfc/Atlantic_sfc_10u_"+year(nyr)+"_11.nc","r")
u10_11 = short2flt(f_u->u10)  ;to apply add_offset and scale_factor
f_v = addfile("/mnt/lustre/proj/jhson/SJ/era5/data/Atlantic3_0.25/sfc/Atlantic_sfc_10v_"+year(nyr)+"_11.nc","r")
v10_11 = short2flt(f_v->v10)  ;to apply add_offset and scale_factor

f_u = addfile("/mnt/lustre/proj/jhson/SJ/era5/data/Atlantic3_0.25/sfc/Atlantic_sfc_10u_"+year(nyr)+"_12.nc","r")
u10_12 = short2flt(f_u->u10)  ;to apply add_offset and scale_factor
f_v = addfile("/mnt/lustre/proj/jhson/SJ/era5/data/Atlantic3_0.25/sfc/Atlantic_sfc_10v_"+year(nyr)+"_12.nc","r")
v10_12 = short2flt(f_v->v10)  ;to apply add_offset and scale_factor

t_1 = dimsizes(v10_1)
t_2 = dimsizes(v10_2)
t_10 = dimsizes(v10_10)
t_11 = dimsizes(v10_11)
t_12 = dimsizes(v10_12)
;print(dimsizes(v10_1))

v = new((/nt,ny,nx/),"float")
;print(dimsizes(v10))
v(0:t_1(0)-1,:,:) = v10_1(:,:,:)
v(t_1(0):t_1(0)+t_2(0)-1,:,:) = v10_2(:,:,:)
v(t_1(0)+t_2(0):t_1(0)+t_2(0)+t_10(0)-1,:,:) = v10_10(:,:,:)
v(t_1(0)+t_2(0)+t_10(0):t_1(0)+t_2(0)+t_10(0)+t_11(0)-1,:,:) = v10_11(:,:,:)
v(t_1(0)+t_2(0)+t_10(0)+t_11(0):t_1(0)+t_2(0)+t_10(0)+t_11(0)+t_12(0)-1,:,:) = v10_12(:,:,:)

u = new((/nt,ny,nx/),"float")
u(0:t_1(0)-1,:,:) = u10_1(:,:,:)
u(t_1(0):t_1(0)+t_2(0)-1,:,:) = u10_2(:,:,:)
u(t_1(0)+t_2(0):t_1(0)+t_2(0)+t_10(0)-1,:,:) = u10_10(:,:,:)
u(t_1(0)+t_2(0)+t_10(0):t_1(0)+t_2(0)+t_10(0)+t_11(0)-1,:,:) = u10_11(:,:,:)
u(t_1(0)+t_2(0)+t_10(0)+t_11(0):t_1(0)+t_2(0)+t_10(0)+t_11(0)+t_12(0)-1,:,:) = u10_12(:,:,:)

do nnum = 0, dim(0)-1
  do t = 0, dim(1)-1
;do nnum = 0, 3-1
;  do t = 0, 3-1
    if storm_track(nnum,t,2) .le. 100000  then
      
      do i = 0, nx-1
        if storm_track(nnum,t,2) .eq. lon(i) then
          ii = i
        end if
      end do

      do j = 0, ny-1
        if storm_track(nnum,t,3) .eq. lat(j) then
          jj = j
        end if
      end do

      do t2 = 0, nt-1
        if storm_track(nnum,t,1) .eq. ttt(t2) then
          tt = t2
        end if
      end do
 
      temp = 0.   ;to consider the anomalous stong wind near surface
      ;do iii2 = ii-20,ii+20 
      ;do jjj2 = jj-20,jj+20 
      ;  temp = temp + sqrt(u(tt,jjj2,iii2)^2 + v(tt,jjj2,iii2)^2)/41/41
      ;end do
      ;end do
 
      do iii = ii-10,ii+10 
      do jjj = jj-10,jj+10 
        ;if w(tt,jjj,iii) .le. 0.0 then    ;intensity of omega at 700hPa

          ;temp = 0.   ;to consider the anomalous stong wind near surface
          ;do iii2 = iii-10,iii+10 
          ;do jjj2 = jjj-10,jjj+10 
          ;  temp = temp + sqrt(u(tt,jjj2,iii2)^2 + v(tt,jjj2,iii2)^2)/121.
          ;end do
          ;end do
 
          omega(count) = w(tt,jjj,iii)    ; 1: existance of SJ(omega)
          windspeed(count) = sqrt(u(tt,jjj,iii)^2 + v(tt,jjj,iii)^2)-temp

          final(tointeger(round(windspeed(count)*multi_grid,2)),tointeger(round((omega(count)*multi_grid)+10*multi_grid,2))) = final(tointeger(round(windspeed(count)*multi_grid,2)),tointeger(round((omega(count)*multi_grid)+10*multi_grid,2)))+1

          final_y(tointeger(round(windspeed(count)*multi_grid,2))) = final_y(tointeger(round(windspeed(count)*multi_grid,2)))+1
          final_x(tointeger(round((omega(count)*multi_grid)+10*multi_grid,2))) = final_x(tointeger(round((omega(count)*multi_grid)+10*multi_grid,2)))+1

          count = count+1
        ;end if
      end do
      end do

    end if
  end do
end do

print(count)

delete([/w,u,u10_1,u10_2,u10_10,u10_11,u10_12,v,v10_1,v10_2,v10_10,v10_11,v10_12,ttt,storm_track/])
end do

;;;;;write nc file
omega!0 = "number"
ttt = ispan(1,200000000,1)
omega&number = ttt

dim = dimsizes(omega)

system("rm -f /mnt/lustre/proj/jhson/SJ/era5/data/Atlantic3_0.25/Atlantic3_SJ_wind10m_downward.nc")

fout = addfile ("/mnt/lustre/proj/jhson/SJ/era5/data/Atlantic3_0.25/Atlantic3_SJ_wind10m_downward.nc","c")
setfileoption(fout,"DefineMode",True)

fAtt               = True            ; assign file attributes
fAtt@title         = "To search sting jet"
fAtt@source_file   =  "omega at 950 hPa, and windspeed at 10m hPa"
fAtt@Conventions   = "None"
fAtt@creation_date = systemfunc ("date")
fileattdef( fout, fAtt )            ; copy file attributes

dimNames = (/"number"/)
dimSizes = (/ dim /)
dimUnlim = (/ False /)
filedimdef(fout,dimNames,dimSizes,dimUnlim)

filevardef(fout, "number"     ,"integer", (/"number"/))
filevardef(fout, "omega"      ,"float",(/"number"/))
filevardef(fout, "windspeed"  ,"float",(/"number"/))

filevarattdef(fout,"number" ,omega&number)
filevarattdef(fout,"omega" ,omega)
filevarattdef(fout,"windspeed" ,windspeed)

setfileoption(fout,"DefineMode",False)

fout->number=(/ttt/)
fout->omega=(/omega/)
fout->windspeed=(/windspeed/)

;;;;;draw
;********************************************
 ;wks = gsn_open_wks("eps","./draw/scatter_plot_omega_windspeed_downward")  ; send graphics to PNG file
 wks = gsn_open_wks("png","./draw/pdf_plot_omega_windspeed_10m_seperate_percentage")   ; send graphics to PNG file

 res                     = True                   ; plot mods desired
 ;res@gsnMaximize         = True                   ; maximize plot in frame
 res@xyMarkLineModes     = (/"Markers","Lines"/)  ; choose which have markers
 res@xyMarkers           = 16                     ; choose type of marker 
 res@xyMarkerColor       = "red"                  ; Marker color
 res@xyMarkerSizeF       = 0.003                  ; Marker size (default 0.01)
 res@xyDashPatterns      = 1                      ; solid line 
 res@xyLineThicknesses   = (/1,2/)                ; set second line to 2
 res@tiXAxisString        = "Pressure velocity at 950 hPa (Pa/s)"
 res@tiYAxisString        = "Horizontal wind speed at 10m (m/s)"
 ;res@tiMainString        = "Atlantic storm wind (1979-2022)"

nVar    = 4
plot    = new ( nVar, "graphic")

xx=ispan(0,20*multi_grid,1)
yy=ispan(0,40*multi_grid,1)
lon_temp = (xx - 10*multi_grid)*1./multi_grid
lat_temp = yy*1./multi_grid

;print(dimsizes(final_y))
;print(dimsizes(lat_temp))
;print(dimsizes(final_x))
;print(dimsizes(lon_temp))

print("step_1")

final_x!0 = "x"
final_y!0 = "y"
final_x&x = lon_temp
final_y&y = lat_temp

final!0 = "y"
final!1 = "x"
final&y = lat_temp
final&x = lon_temp

res@vpWidthF   = 0.6
res@vpHeightF  = 0.6
res@trXMinF = -8
res@trXMaxF = 8
res@trYMinF = 0
res@trYMaxF = 40
;plot = gsn_csm_xy (wks,omega(0:count-1),windspeed(0:count-1),res)        ; create plot  
plot(0) = gsn_csm_xy (wks,omega(0:count-1),windspeed(0:count-1),res)        ; create plot  

cnres                             = True
cnres@cnLevelSelectionMode = "ExplicitLevels"
cnres@vpWidthF   = 0.6
cnres@vpHeightF  = 0.6
cnres@trXMinF = -8
cnres@trXMaxF = 8
cnres@trYMinF = 0
cnres@trYMaxF = 40

cnres@cnLinesOn            = True
cnres@pmLabelBarWidthF            = 0.4
cnres@pmLabelBarHeightF           = 0.10
cnres@pmLabelBarOrthogonalPosF    = 0.15
cnres@lbLabelFontHeightF          = 0.04

;cnres@cnFillOn             = True
cnres@cnInfoLabelOn        = False

cnres@lbLabelBarOn = False
cnres@cnLineLabelsOn  = True
cnres@lbLabelStride       = 1                ; set the label bar label stride to 2
cnres@lbLabelFontHeightF  = 0.015
cnres@cnFillPalette        = "BlAqGrYeOrRe"
;cnres@cnLevels = (/0.00001, 0.0001, 0.001, 0.01, 0.1, 1.0/)  ; Define your desired contour levels
;cnres@cnLevels = (/1e-6, 1e-5, 1e-4, 1e-3, 1e-2, 1e-1, 1e0/)  ; Define your desired contour levels
cnres@cnLevels = (/-5, -4, -3, -2, -1, 0, 1/)  ; Define your desired contour levels
cnres@cnMonoLineColor  = False
cnres@cnLineLabelDensityF      = 3.0             ; <1.0 = less, >1.0 = more
cnres@cnLineColors = (/ "purple","blue","skyblue","green","yellowgreen","yellow","orange" /)
cnres@cnLineThicknessF = 5
cnres@cnLineLabelPlacementMode = "Computed"

print("step_2")
print(dimsizes(final))

do i = 0, 81-1
do j = 0, 41-1
  if final(i,j) .le. 0.00000001 then 
    final(i,j) = -999
  end if
  if final(i,j) .gt. 0.00000001 then
    final(i,j) = log10(final(i,j)/count*100)
  end if
end do
end do

print(final)

print("step_2-1")
plot(1) = gsn_csm_contour(wks,final,cnres)
print("step_2-2")

res_line  = True
res_line@gsnDraw                = False
res_line@gsnFrame               = False
res_line@xyLineThicknessF       = 5

res_y = res_line
res_x = res_line

res_y@tiXAxisString          = "PDF (%)"
res_y@vpWidthF   = 0.1
res_y@vpHeightF  = 0.6
res_y@vpXF       = 0.825
res_y@vpYF       = 0.8
res_y@trYMinF = 0
res_y@trYMaxF = 40
res_y@tmYLOn = False
print("step_3")

;plot = gsn_csm_xy(wks,final_y/count*100,lat_temp, res_y)
plot(2) = gsn_csm_xy(wks,final_y/count*100,lat_temp, res_y)
;overlay(plot, gsn_csm_xy(wks,final_y/count*100,lat_temp, res_y))

;print(final_y/count*100)

print("step_4")
;res_x@trYMinF = 0.001
;res_x@trYMaxF = 100
;res_x@xyYStyle = "Log"
;res_x@trYReverse        = True 
res_x@tiYAxisString          = "PDF (%)"
res_x@vpWidthF   = 0.6
res_x@vpHeightF  = 0.1
res_x@vpXF       = 0.2
res_x@vpYF       = 0.925
res_x@trXMinF = -8
res_x@trXMaxF = 8
res_x@tmXBOn = False
;plot = gsn_csm_xy(wks,lon_temp,final_x/count*100, res_x)
plot(3) = gsn_csm_xy(wks,lon_temp,final_x/count*100, res_x)
;overlay(plot, gsn_csm_xy(wks,lon_temp,final_x/count*100, res_x))

print("step_5")
draw(plot)
frame(wks)

end
