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
;year = ispan(1987,1987,1)

count = 0

do nyr=0, dimsizes(year)-1

;level = 1000, 975, 950, 950, 900, 875, 850, 825, 800, 775, 750, 700, 650, 600, 550, 500, 450, 400, 350, 300, 250, 225, 200, 150 ;
;f_u = addfile("/mnt/lustre/proj/jhson/SJ/era5/data/Atlantic3_0.25/Atlantic3_pl_u_1000_"+year(nyr)+".nc","r")
;u = short2flt(f_u->u)  ;to apply add_offset and scale_factor
;f_v = addfile("/mnt/lustre/proj/jhson/SJ/era5/data/Atlantic3_0.25/Atlantic3_pl_v_1000_"+year(nyr)+".nc","r")
;v = short2flt(f_v->v)  ;to apply add_offset and scale_factor

;f_w = addfile("/mnt/lustre/proj/jhson/SJ/era5/data/Atlantic3_0.25/Atlantic3_pl_w_950_"+year(nyr)+".nc","r")
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

f_iu = addfile("/mnt/lustre/proj/jhson/SJ/era5/data/Atlantic3_0.25/sfc/Atlantic_sfc_instantaneous_10m_wind_gust_"+year(nyr)+"_01.nc","r")
i10fg_1 = short2flt(f_iu->i10fg)  ;to apply add_offset and scale_factor

f_iu = addfile("/mnt/lustre/proj/jhson/SJ/era5/data/Atlantic3_0.25/sfc/Atlantic_sfc_instantaneous_10m_wind_gust_"+year(nyr)+"_02.nc","r")
i10fg_2 = short2flt(f_iu->i10fg)  ;to apply add_offset and scale_factor

f_iu = addfile("/mnt/lustre/proj/jhson/SJ/era5/data/Atlantic3_0.25/sfc/Atlantic_sfc_instantaneous_10m_wind_gust_"+year(nyr)+"_10.nc","r")
i10fg_10 = short2flt(f_iu->i10fg)  ;to apply add_offset and scale_factor

f_iu = addfile("/mnt/lustre/proj/jhson/SJ/era5/data/Atlantic3_0.25/sfc/Atlantic_sfc_instantaneous_10m_wind_gust_"+year(nyr)+"_11.nc","r")
i10fg_11 = short2flt(f_iu->i10fg)  ;to apply add_offset and scale_factor

f_iu = addfile("/mnt/lustre/proj/jhson/SJ/era5/data/Atlantic3_0.25/sfc/Atlantic_sfc_instantaneous_10m_wind_gust_"+year(nyr)+"_12.nc","r")
i10fg_12 = short2flt(f_iu->i10fg)  ;to apply add_offset and scale_factor

t_1 = dimsizes(i10fg_1)
t_2 = dimsizes(i10fg_2)
t_10 = dimsizes(i10fg_10)
t_11 = dimsizes(i10fg_11)
t_12 = dimsizes(i10fg_12)
;print(dimsizes(i10fg_1))

u = new((/nt,ny,nx/),"float")
u(0:t_1(0)-1,:,:) = i10fg_1(:,:,:)
u(t_1(0):t_1(0)+t_2(0)-1,:,:) = i10fg_2(:,:,:)
u(t_1(0)+t_2(0):t_1(0)+t_2(0)+t_10(0)-1,:,:) = i10fg_10(:,:,:)
u(t_1(0)+t_2(0)+t_10(0):t_1(0)+t_2(0)+t_10(0)+t_11(0)-1,:,:) = i10fg_11(:,:,:)
u(t_1(0)+t_2(0)+t_10(0)+t_11(0):t_1(0)+t_2(0)+t_10(0)+t_11(0)+t_12(0)-1,:,:) = i10fg_12(:,:,:)

do nnum = 0, dim(0)-1
  do t = 0, dim(1)-1
    ;print(storm_track(nnum,t,2))
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
        ;if w(tt,jjj,iii) .ge. 1.0 then    ;intensity of omega at 700hPa

          temp = 0.   ;to consider the anomalous stong wind near surface
          ;do iii2 = iii-2,iii+2 
          ;do jjj2 = jjj-2,jjj+2 
          ;  temp = temp + sqrt(u(tt,jjj2,iii2)^2 + v(tt,jjj2,iii2)^2)/25
          ;end do
          ;end do
 
          omega(count) = w(tt,jjj,iii)    ; 1: existance of SJ(omega)
          ;windspeed(count) = sqrt(u(tt,jjj,iii)^2 + v(tt,jjj,iii)^2)
          windspeed(count) = u(tt,jjj,iii)
          ;windspeed(count) = temp
          count = count+1
        ;end if
      end do
      end do

    end if
  end do
end do

print(count)

delete([/w,u,i10fg_1,i10fg_2,i10fg_10,i10fg_11,i10fg_12,ttt,storm_track/])
end do

;;;;;write nc file
omega!0 = "number"
ttt = ispan(1,200000000,1)
omega&number = ttt
dim = dimsizes(omega)

system("rm -f /mnt/lustre/proj/jhson/SJ/era5/data/Atlantic3_0.25/Atlantic3_SJ_950_10m.nc")

fout = addfile ("/mnt/lustre/proj/jhson/SJ/era5/data/Atlantic3_0.25/Atlantic3_SJ_950_10m.nc","c")
setfileoption(fout,"DefineMode",True)

fAtt               = True            ; assign file attributes
fAtt@title         = "To search sting jet"
fAtt@source_file   =  "omega at 950 hPa, and windspeed at 10m"
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
 ;wks = gsn_open_wks("eps","./draw/scatter_plot_omega_windspeed")               ; send graphics to PNG file
 wks = gsn_open_wks("png","./draw/scatter_plot_omega_950_gust_windspeed_10m")         ; send graphics to PNG file

 res                     = True                   ; plot mods desired
 res@gsnMaximize         = True                   ; maximize plot in frame
 res@xyMarkLineModes     = (/"Markers","Lines"/)  ; choose which have markers
 res@xyMarkers           = 16                     ; choose type of marker 
 res@xyMarkerColor       = "red"                  ; Marker color
 res@xyMarkerSizeF       = 0.003                  ; Marker size (default 0.01)
 res@xyDashPatterns      = 1                      ; solid line 
 res@xyLineThicknesses   = (/1,2/)                ; set second line to 2
 res@tiXAxisString        = "Pressure velocity at 950 hPa (Pa/s)"
 res@tiYAxisString        = "Horizontal gust wind speed at 10 m (m/s)"
 ;res@tiMainString        = "Atlantic storm wind in 2012"
 res@tiMainString        = "Atlantic storm wind 79-22"

 plot  = gsn_csm_xy (wks,omega(0:count-1),windspeed(0:count-1),res)        ; create plot   

 ;frame(wks)

end
