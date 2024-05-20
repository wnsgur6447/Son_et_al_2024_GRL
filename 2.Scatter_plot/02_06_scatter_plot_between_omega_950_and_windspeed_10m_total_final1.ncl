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
;year = ispan(1979,1980,1)

count = 0

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
 wks = gsn_open_wks("png","./draw/scatter_plot_omega_windspeed_10m_total")   ; send graphics to PNG file

 res                     = True                   ; plot mods desired
 res@gsnMaximize         = True                   ; maximize plot in frame
 res@xyMarkLineModes     = (/"Markers","Lines"/)  ; choose which have markers
 res@xyMarkers           = 16                     ; choose type of marker 
 res@xyMarkerColor       = "red"                  ; Marker color
 res@xyMarkerSizeF       = 0.003                  ; Marker size (default 0.01)
 res@xyDashPatterns      = 1                      ; solid line 
 res@xyLineThicknesses   = (/1,2/)                ; set second line to 2
 res@tiXAxisString        = "Pressure velocity at 950 hPa (Pa/s)"
 res@tiYAxisString        = "Horizontal wind speed at 10m (m/s)"
 res@tiMainString        = "Atlantic storm wind (1979-2022)"

 plot  = gsn_csm_xy (wks,omega(0:count-1),windspeed(0:count-1),res)        ; create plot   

 ;frame(wks)

end
