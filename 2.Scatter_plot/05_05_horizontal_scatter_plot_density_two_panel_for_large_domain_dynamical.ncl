;
; These files are loaded by default in NCL V6.2.0 and newer
; load "$NCARG_ROOT/lib/ncarg/nclscripts/csm/gsn_code.ncl"
; load "$NCARG_ROOT/lib/ncarg/nclscripts/csm/gsn_csm.ncl"
;**************************************************
begin
;**************************************************

;lon_final = new((/10000000/),"float")
;lat_final = new((/10000000/),"float")
;lon_final_meridional = new((/10000000/),"float")
;lat_final_meridional = new((/10000000/),"float")
;lon_final_zonal = new((/10000000/),"float")
;lat_final_zonal = new((/10000000/),"float")
;omega     = new((/10000000/),"float")

;lon_final(:) = 1e20
;lat_final(:) = 1e20
;lon_final_meridional(:) = 1e20
;lat_final_meridional(:) = 1e20
;lon_final_zonal(:) = 1e20
;lat_final_zonal(:) = 1e20
;omega(:) = 1e20

zonal = new((/41,41/),"float")
meridional = new((/41,41/),"float")
total = new((/41,41/),"float")

zonal(:,:) = 0
meridional(:,:) = 0
total(:,:) = 0

   xx = ispan(0,40,1)
   yy = ispan(0,40,1)
   lon_temp = xx/4. -5.0
   lat_temp = (yy/4. -5.0)*(-1)

;print(lon_temp)
;print(lat_temp)

year = ispan(1979,2022,1)
;year = ispan(2010,2015,1)

count = 0.0
count_meridional = 0.0
count_zonal = 0.0

do nyr=0, dimsizes(year)-1

;level = 1000, 975, 950, 975, 900, 875, 950, 950, 800, 950, 750, 700, 650, 600, 550, 500, 450, 400, 350, 300, 250, 225, 200, 150 ;
f_u = addfile("/mnt/lustre/proj/jhson/SJ/era5/data/Atlantic3_0.25/Atlantic3_pl_theta_e_925_"+year(nyr)+".nc","r")
;t = short2flt(f_u->t)  ;to apply add_offset and scale_factor
theta_e = f_u->theta_e

f_t_dxdy = addfile("/mnt/lustre/proj/jhson/SJ/era5/data/Atlantic3_0.25/Atlantic3_pl_u_dx_dy_925_"+year(nyr)+".nc","r")
dx = f_t_dxdy->dvar_dx

f_t_dxdy = addfile("/mnt/lustre/proj/jhson/SJ/era5/data/Atlantic3_0.25/Atlantic3_pl_v_dx_dy_925_"+year(nyr)+".nc","r")
dy = f_t_dxdy->dvar_dy

f_w = addfile("/mnt/lustre/proj/jhson/SJ/era5/data/Atlantic3_0.25/Atlantic3_pl_w_950_"+year(nyr)+".nc","r")
;w = f_t->w
w = short2flt(f_w->w)  ;to apply add_offset and scale_factor
lon = f_w->longitude
lat = f_w->latitude
ttt = f_w->time

;print(lat)

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

;f_u = addfile("/mnt/lustre/proj/jhson/SJ/era5/data/Atlantic3_0.25/sfc/Atlantic_sfc_10u_"+year(nyr)+"_01.nc","r")
;u10_1 = short2flt(f_u->u10)  ;to apply add_offset and scale_factor
;f_v = addfile("/mnt/lustre/proj/jhson/SJ/era5/data/Atlantic3_0.25/sfc/Atlantic_sfc_10v_"+year(nyr)+"_01.nc","r")
;v10_1 = short2flt(f_v->v10)  ;to apply add_offset and scale_factor
;
;f_u = addfile("/mnt/lustre/proj/jhson/SJ/era5/data/Atlantic3_0.25/sfc/Atlantic_sfc_10u_"+year(nyr)+"_02.nc","r")
;u10_2 = short2flt(f_u->u10)  ;to apply add_offset and scale_factor
;f_v = addfile("/mnt/lustre/proj/jhson/SJ/era5/data/Atlantic3_0.25/sfc/Atlantic_sfc_10v_"+year(nyr)+"_02.nc","r")
;v10_2 = short2flt(f_v->v10)  ;to apply add_offset and scale_factor
;
;f_u = addfile("/mnt/lustre/proj/jhson/SJ/era5/data/Atlantic3_0.25/sfc/Atlantic_sfc_10u_"+year(nyr)+"_10.nc","r")
;u10_10 = short2flt(f_u->u10)  ;to apply add_offset and scale_factor
;f_v = addfile("/mnt/lustre/proj/jhson/SJ/era5/data/Atlantic3_0.25/sfc/Atlantic_sfc_10v_"+year(nyr)+"_10.nc","r")
;v10_10 = short2flt(f_v->v10)  ;to apply add_offset and scale_factor
;
;f_u = addfile("/mnt/lustre/proj/jhson/SJ/era5/data/Atlantic3_0.25/sfc/Atlantic_sfc_10u_"+year(nyr)+"_11.nc","r")
;u10_11 = short2flt(f_u->u10)  ;to apply add_offset and scale_factor
;f_v = addfile("/mnt/lustre/proj/jhson/SJ/era5/data/Atlantic3_0.25/sfc/Atlantic_sfc_10v_"+year(nyr)+"_11.nc","r")
;v10_11 = short2flt(f_v->v10)  ;to apply add_offset and scale_factor
;
;f_u = addfile("/mnt/lustre/proj/jhson/SJ/era5/data/Atlantic3_0.25/sfc/Atlantic_sfc_10u_"+year(nyr)+"_12.nc","r")
;u10_12 = short2flt(f_u->u10)  ;to apply add_offset and scale_factor
;f_v = addfile("/mnt/lustre/proj/jhson/SJ/era5/data/Atlantic3_0.25/sfc/Atlantic_sfc_10v_"+year(nyr)+"_12.nc","r")
;v10_12 = short2flt(f_v->v10)  ;to apply add_offset and scale_factor

;t_1 = dimsizes(v10_1)
;t_2 = dimsizes(v10_2)
;t_10 = dimsizes(v10_10)
;t_11 = dimsizes(v10_11)
;t_12 = dimsizes(v10_12)
;;print(dimsizes(v10_1))

;v10 = new((/nt,ny,nx/),"float")
;;print(dimsizes(v10))
;v10(0:t_1(0)-1,:,:) = v10_1(:,:,:)
;v10(t_1(0):t_1(0)+t_2(0)-1,:,:) = v10_2(:,:,:)
;v10(t_1(0)+t_2(0):t_1(0)+t_2(0)+t_10(0)-1,:,:) = v10_10(:,:,:)
;v10(t_1(0)+t_2(0)+t_10(0):t_1(0)+t_2(0)+t_10(0)+t_11(0)-1,:,:) = v10_11(:,:,:)
;v10(t_1(0)+t_2(0)+t_10(0)+t_11(0):t_1(0)+t_2(0)+t_10(0)+t_11(0)+t_12(0)-1,:,:) = v10_12(:,:,:)
;
;u10 = new((/nt,ny,nx/),"float")
;u10(0:t_1(0)-1,:,:) = u10_1(:,:,:)
;u10(t_1(0):t_1(0)+t_2(0)-1,:,:) = u10_2(:,:,:)
;u10(t_1(0)+t_2(0):t_1(0)+t_2(0)+t_10(0)-1,:,:) = u10_10(:,:,:)
;u10(t_1(0)+t_2(0)+t_10(0):t_1(0)+t_2(0)+t_10(0)+t_11(0)-1,:,:) = u10_11(:,:,:)
;u10(t_1(0)+t_2(0)+t_10(0)+t_11(0):t_1(0)+t_2(0)+t_10(0)+t_11(0)+t_12(0)-1,:,:) = u10_12(:,:,:)

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
      ;print(storm_track(nnum,0:10,4))
      ;print(ttt(0))
      ;print(ttt(3647))
 
      temp = 0.   ;to consider the anomalous stong wind near surface
      ;do iii2 = ii-20,ii+20 
      ;do jjj2 = jj-20,jj+20 
      ;  temp = temp + sqrt(theta_e(tt,jjj2,iii2)^2 + theta_e(tt,jjj2,iii2)^2)/41/41
      ;end do
      ;end do
 
      do iii = ii-20,ii+20 
      do jjj = jj-20,jj+20 
        ;if (w(tt,jjj,iii) .ge. 3.0) .and. ((dx(tt,jjj,iii)*theta_e(tt,jjj,iii)+dy(tt,jjj,iii)*theta_e(tt,jjj,iii)) .gt. 0.001) then    ;intensity of omega at 950hPa
        ;if (w(tt,jjj,iii) .ge. 3.0) then    ;intensity of omega at 950hPa
        if (w(tt,jjj,iii) .ge. 0.0) then    ;intensity of omega at 950hPa
 
          ;omega(count) = w(tt,jjj,iii)    ; 1: existance of SJ(omega)
          ;lon_final(count) = lon(iii)-lon(ii)
          ;lat_final(count) = lat(jjj)-lat(jj)

          ;if (dx(tt,jjj,iii)*theta_e(tt,jjj,iii)*(-1) .gt. dy(tt,jjj,iii)*theta_e(tt,jjj,iii)*(-1)) .and. (dx(tt,jjj,iii)*theta_e(tt,jjj,iii)*(-1) .gt. 0) then
          if (dx(tt,jjj,iii)*theta_e(tt,jjj,iii)*(-1) .gt. dy(tt,jjj,iii)*theta_e(tt,jjj,iii)*(-1)) then
          ;if (dx(tt,jjj,iii) .gt. 0) then
            ;lon_final_meridional(count_meridional) = lon(iii)-lon(ii)
            ;lat_final_meridional(count_meridional) = lat(jjj)-lat(jj)
            count_zonal = count_zonal + 1.0
            zonal(jjj-jj+20,iii-ii+20) = zonal(jjj-jj+20,iii-ii+20) + 1.0
          end if          

          ;if (dx(tt,jjj,iii)*theta_e(tt,jjj,iii)*(-1) .lt. dy(tt,jjj,iii)*theta_e(tt,jjj,iii)*(-1)) .and. (dy(tt,jjj,iii)*theta_e(tt,jjj,iii)*(-1) .gt. 0) then
          if (dx(tt,jjj,iii)*theta_e(tt,jjj,iii)*(-1) .lt. dy(tt,jjj,iii)*theta_e(tt,jjj,iii)*(-1)) then
          ;if (dy(tt,jjj,iii) .gt. 0) then
            ;lon_final_zonal(count_zonal) = lon(iii)-lon(ii)
            ;lat_final_zonal(count_zonal) = lat(jjj)-lat(jj)
            count_meridional = count_meridional + 1.0
            meridional(jjj-jj+20,iii-ii+20) = meridional(jjj-jj+20,iii-ii+20) + 1.0
          end if          

          total(jjj-jj+20,iii-ii+20) = total(jjj-jj+20,iii-ii+20) + 1.0
          ;count = count+1
        end if
      end do
      end do
      count = count + 1.0

    end if
  end do
end do

print(count)
;print(count_meridional)
;print(count_zonal)

;delete([/w,u,v,u10,u10_1,u10_2,u10_10,u10_11,u10_12,v10,v10_1,v10_2,v10_10,v10_11,v10_12,dx,dy,ttt,storm_track/])
delete([/w,theta_e,dx,dy,ttt,storm_track/])
end do

;;;;;write nc file
;omega!0 = "number"
;ttt = ispan(1,10000000,1)
;omega&number = ttt
;dim = dimsizes(omega)
;
;system("rm -f /mnt/lustre/proj/jhson/SJ/era5/data/Atlantic3_0.25/Atlantic3_SJ_wind_10m_lat_final950_downward_with_respect_phase.nc")
;
;fout = addfile ("/mnt/lustre/proj/jhson/SJ/era5/data/Atlantic3_0.25/Atlantic3_SJ_wind_10m_lat_final950_downward_with_respect_phase.nc","c")
;setfileoption(fout,"DefineMode",True)
;
;fAtt               = True            ; assign file attributes
;fAtt@title         = "To search sting jet"
;fAtt@source_file   =  "lon_final at 10m, and lat_final at 950 hPa when omega greater than 1 Pa/s"
;fAtt@Conventions   = "None"
;fAtt@creation_date = systemfunc ("date")
;fileattdef( fout, fAtt )            ; copy file attributes
;
;dimNames = (/"number"/)
;dimSizes = (/ dim /)
;dimUnlim = (/ False /)
;filedimdef(fout,dimNames,dimSizes,dimUnlim)
;
;filevardef(fout, "number"     ,"integer", (/"number"/))
;filevardef(fout, "omega"      ,"float",(/"number"/))
;filevardef(fout, "lat_final"  ,"float",(/"number"/))
;
;filevarattdef(fout,"number" ,omega&number)
;filevarattdef(fout,"omega" ,omega)
;filevarattdef(fout,"lat_final" ,lat_final)
;
;setfileoption(fout,"DefineMode",False)
;
;fout->number=(/ttt/)
;fout->omega=(/omega/)
;fout->lat_final=(/lat_final/)

;;;;;draw
;********************************************
 wks = gsn_open_wks("png","./draw/horizontal_scatter_plot_density_large_domain_dynamical")   ; send graphics to PNG file
   res            = True                          ; map resources
   res@gsnMaximize= True         ; make ps, pdf, eps, .. large
   res@gsnDraw    = False                         ; don't draw
   res@gsnFrame   = False                         ; don't advance frame
   res@vpWidthF   = 0.80                          ; make map bigger
   res@vpHeightF  = 0.80

   ;res@mpMaxLonF  = 2.5
   ;res@mpMinLonF  = -2.5
   ;res@mpMaxLatF  = 2.5                           ; select subregion
   ;res@mpMinLatF  = -2.5

   ;res@gsnCenterString = "(Winter 1979-2022)"   ; center string

   ;res@mpDataBaseVersion     = "MediumRes"               ; better map outlines
   res@pmTickMarkDisplayMode = "Always"                  ; better map tickmarks

;;set contour;;
        cnres                             = res
        cnres@cnLevelSelectionMode = "ManualLevels"
        ;gsn_define_colormap(wks,"cmp_b2r")
        gsn_define_colormap(wks,"cmocean_deep")

        cnres@cnLinesOn                   = False
        cnres@pmLabelBarWidthF            = 0.4
        cnres@pmLabelBarHeightF           = 0.10
        cnres@pmLabelBarOrthogonalPosF    = 0.15
        cnres@lbLabelFontHeightF          = 0.04

        cnres@cnFillOn             = True
        cnres@cnLinesOn            = False
        cnres@cnInfoLabelOn        = False

        cnres@lbLabelBarOn = True
        cnres@cnLineLabelsOn  = False
        cnres@lbLabelStride       = 1                ; set the label bar label stride to 2
        cnres@lbLabelFontHeightF  = 0.015

        ;cmap = read_colormap_file("BlWhRe")
        ;cmap = read_colormap_file("MPL_RdYlGn")
        cmap = read_colormap_file("MPL_summer")
        ;cmap = cmap(::-1,:)  ;reverse the color map
        cnres@cnFillPalette        = cmap

        ;cnres@cnLevelSpacingF = 0.05                      ; set the interval between contours
        ;cnres@cnMinLevelValF  = 0                 ; set the minimum contour level
        ;cnres@cnMaxLevelValF  = 1.0                     ; set the maximum contour level

        ;cnres@cnLevelSpacingF = 2.0                      ; set the interval between contours
        ;cnres@cnMinLevelValF  = 14                 ; set the minimum contour level
        ;cnres@cnMaxLevelValF  = 56.0                     ; set the maximum contour level

;;dot 
 dot_res                     = True                   ; plot mods desired
 dot_res@gsnMaximize         = True                   ; maximize plot in frame
 dot_res@xyMarkLineModes     = (/"Markers","Lines"/)  ; choose which have markers
 dot_res@xyMarkers           = 16                     ; choose type of marker 
 dot_res@xyMarkerSizeF       = 0.025                  ; Marker size (default 0.01)
 dot_res@xyDashPatterns      = 1                      ; solid line 
 dot_res@xyLineThicknesses   = (/1,2/)                ; set second line to 2
 dot_res@xyMarkerColor       = "black"  

;   zonal(:,:) = zonal(:,:)/tofloat(count_zonal)*100
   zonal(:,:) = zonal(:,:)/tofloat(count)*100

;   meridional(:,:) = meridional(:,:)/tofloat(count_meridional)*100
   meridional(:,:) = meridional(:,:)/tofloat(count)*100

   total(:,:) = total(:,:)/tofloat(count)*100

;;;;;;;;;;;;;;;;;;;;;;;;;;;;for circle filter
circle_filter = new((/41,41/),"float")
;circle_filter@_FillValue = -999
circle_filter(:,:) = -999
pi = get_pi("Float")
;print(cos(pi)) 

;print(circle_filter)

degree = tofloat(ispan(0,120,1))
degree = degree/60.
x_filter = (5*cos(degree*pi))
y_filter = (5*sin(degree*pi))
;print(x_filter)
;print(y_filter)

x_min = new((/121/),"float")
y_min = new((/121/),"float")
do n = 0, 120
  x_min(n) = minind(abs(x_filter(n)-lon_temp))
end do

do n = 0, 120
  y_min(n) = minind(abs(y_filter(n)-lat_temp))
end do

;print(x_min)
;print(y_min)

do n = 0, 120
    circle_filter(tointeger(x_min(n)),tointeger(y_min(n))) = 1
end do

;print(circle_filter)

do j = 0, 40
do i = 0, 20
  if (circle_filter(i,j) .eq. 1) then
    ;print(i)
    do ii = i, 40-i
    circle_filter(ii,j) = 1
    end do
  end if
end do
end do

do i = 0, 40
do j = 0, 40
  if circle_filter(i,j) .eq. -999 then
  zonal(i,j) = -999
  meridional(i,j) = -999
  total(i,j) = -999
  end if
end do
end do
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

   zonal!0 = "y"
   zonal!1 = "x"
   zonal&y = lat_temp
   zonal&x = lon_temp
   zonal@_FillValue = -999

   meridional!0 = "y"
   meridional!1 = "x"
   meridional&y = lat_temp
   meridional&x = lon_temp
   meridional@_FillValue = -999

   total!0 = "y"
   total!1 = "x"
   total&y = lat_temp
   total&x = lon_temp
   total@_FillValue = -999

   shading = new(3, graphic)
   ;cnres@cnLevelSpacingF = 2.0                      ; set the interval between contours
   ;cnres@cnMinLevelValF  = 32                 ; set the minimum contour level
   ;cnres@cnMaxLevelValF  = 60                     ; set the maximum contour level
   cnres@cnLevelSpacingF = 1.0                      ; set the interval between contours
   cnres@cnMinLevelValF  = 34                 ; set the minimum contour level
   cnres@cnMaxLevelValF  = 54                     ; set the maximum contour level
   shading(0) = gsn_csm_contour(wks,total,cnres)

   ;cnres@cnLevelSpacingF = 2.0                      ; set the interval between contours
   ;cnres@cnMinLevelValF  = 14                 ; set the minimum contour level
   ;cnres@cnMaxLevelValF  = 42                     ; set the maximum contour level
   cnres@cnLevelSpacingF = 1.0                      ; set the interval between contours
   cnres@cnMinLevelValF  = 16                 ; set the minimum contour level
   cnres@cnMaxLevelValF  = 36                     ; set the maximum contour level
   shading(1) = gsn_csm_contour(wks,zonal,cnres)

   ;cnres@cnLevelSpacingF = 2.0                      ; set the interval between contours
   ;cnres@cnMinLevelValF  = 14                 ; set the minimum contour level
   ;cnres@cnMaxLevelValF  = 42                     ; set the maximum contour level
   cnres@cnLevelSpacingF = 1.0                      ; set the interval between contours
   cnres@cnMinLevelValF  = 16                 ; set the minimum contour level
   cnres@cnMaxLevelValF  = 36                     ; set the maximum contour level
   shading(2) = gsn_csm_contour(wks,meridional,cnres)

  zeros = (/0,0,0/)
  overlay(shading(0),gsn_csm_xy(wks,zeros,zeros,dot_res))
  overlay(shading(1),gsn_csm_xy(wks,zeros,zeros,dot_res))
  overlay(shading(2),gsn_csm_xy(wks,zeros,zeros,dot_res))

 panres                     = True
 panres@gsnMaximize         = True             ; maximize the plots
 panres@gsnPanelLabelBar    = True             ; turn on the panel label bar
 panres@gsnPaperOrientation = "auto"       ; make sure the paper orientation is set to portrait
 panres@lbLabelBarOn = False

 gsn_panel(wks,shading,(/1,3/),panres)
 ;draw(plot)
 ;frame(wks)
end
