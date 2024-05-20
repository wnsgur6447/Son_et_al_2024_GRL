;
; These files are loaded by default in NCL V6.2.0 and newer
; load "$NCARG_ROOT/lib/ncarg/nclscripts/csm/gsn_code.ncl"
; load "$NCARG_ROOT/lib/ncarg/nclscripts/csm/gsn_csm.ncl"
;**************************************************
begin
;**************************************************

f_t = addfile("/mnt/lustre/proj/jhson/SJ/era5/data/Atlantic3_0.25/Atlantic3_storm_tracking_1979.nc","r")
storm = f_t->storm
lon = f_t->longitude
lat = f_t->latitude
ttt = f_t->time

year = ispan(1979,2022,1)
;year = ispan(1979,1980,1)

nx = dimsizes(lon)
ny = dimsizes(lat)
nt  = dimsizes(ttt)
nyr = dimsizes(year)

storm_Jan = new((/nyr,ny,nx/),"float") ;
storm_Feb = new((/nyr,ny,nx/),"float") ;
storm_Oct = new((/nyr,ny,nx/),"float") ;
storm_Nov = new((/nyr,ny,nx/),"float") ;
storm_Dec = new((/nyr,ny,nx/),"float") ;

storm_Jan(:,:,:) = 0
storm_Feb(:,:,:) = 0
storm_Oct(:,:,:) = 0
storm_Nov(:,:,:) = 0
storm_Dec(:,:,:) = 0

count_Jan = new((/2,nyr/),"float")
count_Feb = new((/2,nyr/),"float")
count_Oct = new((/2,nyr/),"float")
count_Nov = new((/2,nyr/),"float")
count_Dec = new((/2,nyr/),"float")

count_Jan(:,:) = 0
count_Feb(:,:) = 0
count_Oct(:,:) = 0
count_Nov(:,:) = 0
count_Dec(:,:) = 0

do yr=0, dimsizes(year)-1
print(yr)

f_t = addfile("/mnt/lustre/proj/jhson/SJ/era5/data/Atlantic3_0.25/Atlantic3_storm_tracking_"+year(yr)+".nc","r")
storm = f_t->storm
lon = f_t->longitude
lat = f_t->latitude
ttt = f_t->time

f_w = addfile("/mnt/lustre/proj/jhson/SJ/era5/data/Atlantic3_0.25/Atlantic3_pl_w_950_"+year(yr)+".nc","r")
;w = f_t->w
w = short2flt(f_w->w)  ;to apply add_offset and scale_factor

;print(lat)

nx = dimsizes(lon)
ny = dimsizes(lat)
nt  = dimsizes(ttt)
nyr = dimsizes(year)

;[0:number, 1:nctime, 2:longitude, 3:latitude, 4:timedimension, 5:duration, 6:year, 7:month, 8:day, 9:hour]
radius = 10  ;10 means 2.5 degree 

;;;;;search storm 
do t = 0, nt-1
  do j = 0, ny-1
    do i = 0, nx-1
      if (storm(t,j,i) .eq. 100) then
        t_temp = ut_calendar(ttt(t),0)
        temp = 0
        if tointeger(t_temp(0,1)) .eq. 1 then  ;month
          do ii = i-radius, i+radius
          do jj = j-radius, j+radius
            storm_Jan(yr,jj,ii) = storm_Jan(yr,jj,ii)+1
            if w(yr,jj,ii) .ge. 3.0 then
              temp = 1
            end if
          end do
          end do
          count_Jan(0,yr) = count_Jan(0,yr) + 1
          count_Jan(1,yr) = count_Jan(1,yr) + temp
        else if tointeger(t_temp(0,1)) .eq. 2 then  ;month
          do ii = i-radius, i+radius
          do jj = j-radius, j+radius
            storm_Feb(yr,jj,ii) = storm_Feb(yr,jj,ii)+1
            if w(yr,jj,ii) .ge. 3.0 then
              temp = 1
            end if
          end do
          end do
          count_Feb(0,yr) = count_Feb(0,yr) + 1
          count_Feb(1,yr) = count_Feb(1,yr) + temp
        else if tointeger(t_temp(0,1)) .eq. 10 then  ;month
          do ii = i-radius, i+radius
          do jj = j-radius, j+radius
            storm_Oct(yr,jj,ii) = storm_Oct(yr,jj,ii)+1
            if w(yr,jj,ii) .ge. 3.0 then
              temp = 1
            end if
          end do
          end do
          count_Oct(0,yr) = count_Oct(0,yr) + 1
          count_Oct(1,yr) = count_Oct(1,yr) + temp
        else if tointeger(t_temp(0,1)) .eq. 11 then  ;month
          do ii = i-radius, i+radius
          do jj = j-radius, j+radius
            storm_Nov(yr,jj,ii) = storm_Nov(yr,jj,ii)+1
            if w(yr,jj,ii) .ge. 3.0 then
              temp = 1
            end if
          end do
          end do
          count_Nov(0,yr) = count_Nov(0,yr) + 1
          count_Nov(1,yr) = count_Nov(1,yr) + temp
        else if tointeger(t_temp(0,1)) .eq. 12 then  ;month
          do ii = i-radius, i+radius
          do jj = j-radius, j+radius
            storm_Dec(yr,jj,ii) = storm_Dec(yr,jj,ii)+1
            if w(yr,jj,ii) .ge. 3.0 then
              temp = 1
            end if
          end do
          end do
          count_Dec(0,yr) = count_Dec(0,yr) + 1
          count_Dec(1,yr) = count_Dec(1,yr) + temp
        end if
        end if
        end if
        end if
        end if
      end if
    end do
  end do
end do

delete([/w,ttt,storm/])
end do ;yr

;;;;;write nc file
storm_Jan!0 = "year"
storm_Jan!1 = "latitude"
storm_Jan!2 = "longitude"
storm_Jan&year = year
storm_Jan&latitude = lat
storm_Jan&longitude = lon

system("rm -f /mnt/lustre/proj/jhson/SJ/era5/data/Atlantic3_0.25/Atlantic3_storm_track_density_1979_2022.nc")

fout = addfile ("/mnt/lustre/proj/jhson/SJ/era5/data/Atlantic3_0.25/Atlantic3_storm_track_density_1979_2022.nc","c")
setfileoption(fout,"DefineMode",True)

fAtt               = True            ; assign file attributes
fAtt@title         = "Track Density"
fAtt@source_file   =  "in hourly"
fAtt@Conventions   = "None"
fAtt@creation_date = systemfunc ("date")
fileattdef( fout, fAtt )            ; copy file attributes

dimNames = (/"type",  "year" , "latitude", "longitude"/)
dimSizes = (/   2  ,   nyr   ,         ny,          nx/)
dimUnlim = (/ False,   False ,      False,       False/)
filedimdef(fout,dimNames,dimSizes,dimUnlim)

filevardef(fout, "year"    ,"float", (/"year"/))
filevardef(fout, "latitude"  ,"float", (/"latitude"/))
filevardef(fout, "longitude" ,"float", (/"longitude"/))
filevardef(fout, "storm_Jan"  ,"float",(/"year","latitude","longitude"/))
filevardef(fout, "storm_Feb"  ,"float",(/"year","latitude","longitude"/))
filevardef(fout, "storm_Oct"  ,"float",(/"year","latitude","longitude"/))
filevardef(fout, "storm_Nov"  ,"float",(/"year","latitude","longitude"/))
filevardef(fout, "storm_Dec"  ,"float",(/"year","latitude","longitude"/))
filevardef(fout, "count_Jan"  ,"float",(/"type","year"/))
filevardef(fout, "count_Feb"  ,"float",(/"type","year"/))
filevardef(fout, "count_Oct"  ,"float",(/"type","year"/))
filevardef(fout, "count_Nov"  ,"float",(/"type","year"/))
filevardef(fout, "count_Dec"  ,"float",(/"type","year"/))

filevarattdef(fout,"year" ,year)
filevarattdef(fout,"latitude"  ,lat)
filevarattdef(fout,"longitude"  ,lon)
filevarattdef(fout,"storm_Jan" ,storm_Jan)
filevarattdef(fout,"storm_Feb" ,storm_Feb)
filevarattdef(fout,"storm_Oct" ,storm_Oct)
filevarattdef(fout,"storm_Nov" ,storm_Nov)
filevarattdef(fout,"storm_Dec" ,storm_Dec)
filevarattdef(fout,"count_Jan" ,count_Jan)
filevarattdef(fout,"count_Feb" ,count_Feb)
filevarattdef(fout,"count_Oct" ,count_Oct)
filevarattdef(fout,"count_Nov" ,count_Nov)
filevarattdef(fout,"count_Dec" ,count_Dec)

setfileoption(fout,"DefineMode",False)

fout->year=(/year/)
fout->latitude=(/lat/)
fout->longitude=(/lon/)

fout->storm_Jan=(/storm_Jan/)
fout->storm_Feb=(/storm_Feb/)
fout->storm_Oct=(/storm_Oct/)
fout->storm_Nov=(/storm_Nov/)
fout->storm_Dec=(/storm_Dec/)

fout->count_Jan=(/count_Jan/)
fout->count_Feb=(/count_Feb/)
fout->count_Oct=(/count_Oct/)
fout->count_Nov=(/count_Nov/)
fout->count_Dec=(/count_Dec/)

;;;;;draw
;********************************************
   wks = gsn_open_wks("png","./draw/track_density")
   res            = True                          ; map resources
   res@gsnMaximize= True         ; make ps, pdf, eps, .. large
   res@gsnDraw    = False                         ; don't draw
   res@gsnFrame   = False                         ; don't advance frame
   res@vpWidthF   = 0.80                          ; make map bigger
   res@vpHeightF  = 0.80

   res@mpMaxLatF  = 75                           ; select subregion
   res@mpMinLatF  = 25
   res@mpMinLonF  = -80
   res@mpMaxLonF  = 30

   res@tiMainString    = "Atlantic storms" ;title
   res@gsnCenterString = "(Winter 1979-2022)"   ; center string

   res@mpDataBaseVersion     = "MediumRes"               ; better map outlines
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
        cnres@cnFillPalette        = "BlWhRe"

;;plot
   Jan = dim_avg_n(storm_Jan,0) 
   Feb = dim_avg_n(storm_Feb,0) 
   Oct = dim_avg_n(storm_Oct,0) 
   Nov = dim_avg_n(storm_Nov,0) 
   Dec = dim_avg_n(storm_Dec,0) 

   Jan!0 = "lat"
   Jan!1 = "lon"
   Jan&lat = lat
   Jan&lon = lon

   Feb!0 = "lat"
   Feb!1 = "lon"
   Feb&lat = lat
   Feb&lon = lon

   Oct!0 = "lat"
   Oct!1 = "lon"
   Oct&lat = lat
   Oct&lon = lon

   Nov!0 = "lat"
   Nov!1 = "lon"
   Nov&lat = lat
   Nov&lon = lon

   Dec!0 = "lat"
   Dec!1 = "lon"
   Dec&lat = lat
   Dec&lon = lon

   plot = new(5, graphic)
   contour = new(5, graphic)

   plot(0)     = gsn_csm_map(wks,res)
   plot(1)     = gsn_csm_map(wks,res)
   plot(2)     = gsn_csm_map(wks,res)
   plot(3)     = gsn_csm_map(wks,res)
   plot(4)     = gsn_csm_map(wks,res)
   contour(0) = gsn_csm_contour(wks,Oct(:,:),cnres)
   contour(1) = gsn_csm_contour(wks,Nov(:,:),cnres)
   contour(2) = gsn_csm_contour(wks,Dec(:,:),cnres)
   contour(3) = gsn_csm_contour(wks,Jan(:,:),cnres)
   contour(4) = gsn_csm_contour(wks,Feb(:,:),cnres)

   overlay(plot(0),contour(0))
   overlay(plot(1),contour(1))
   overlay(plot(2),contour(2))
   overlay(plot(3),contour(3))
   overlay(plot(4),contour(4))

 panres                     = True
 panres@gsnMaximize         = True             ; maximize the plots
 panres@gsnPanelLabelBar    = True             ; turn on the panel label bar
 panres@gsnPaperOrientation = "auto"       ; make sure the paper orientation is set to portrait
 panres@lbLabelBarOn = False

 gsn_panel(wks,plot,(/5,1/),panres)
       
 ;frame(wks)
end
