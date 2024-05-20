;
; These files are loaded by default in NCL V6.2.0 and newer
; load "$NCARG_ROOT/lib/ncarg/nclscripts/csm/gsn_code.ncl"
; load "$NCARG_ROOT/lib/ncarg/nclscripts/csm/gsn_csm.ncl"
;**************************************************
begin
;**************************************************

;lev = (/"1000","975","950","925","900","875","850","825","800","775","750","700","650","600","500","400","300","250","200","150","100"/)
year = ispan(1979,2022,1)
;mon = (/"01","02","03","04","05","06","07","08","09","10","11","12"/)

;do nyr=0, dimsizes(year)-1
do nyr=34, dimsizes(year)-1

f_t = addfile("/mnt/lustre/proj/jhson/SJ/era5/data/Atlantic3_0.25/Atlantic3_pl_z_850_"+year(nyr)+".nc","r")
;T = f_t->t
hgt = short2flt(f_t->z)/9.8  ;to apply add_offset and scale_factor
lon = f_t->longitude
lat = f_t->latitude
ttt = f_t->time

nx = dimsizes(lon)
ny = dimsizes(lat)
day  = dimsizes(ttt)
degree = 0.25

;print(nx)
;print(ny)
;print(nz)
;print(day)

storm_temp = new((/day,ny,nx/),"float")
storm_temp2 = new((/day,ny,nx/),"float")
storm_temp(:,:,:) = 0.
storm_temp2(:,:,:) = 0.

halp_window = 10  ;10 means 2.5

 do t = 0, day-1
   do j = halp_window, ny-halp_window-1
     do i = halp_window, nx-halp_window-1
       storm_temp(t,j,i) = storm_temp(t,j,i)+sum(hgt(t,j-halp_window:j+halp_window,i-halp_window:i+halp_window))/(halp_window*2+1)^2    ;for smoothing
     end do
    end do
 end do


 do t = 0, day-1
   do i = halp_window*2, nx-halp_window*2-1
     do j = halp_window*2, ny-halp_window*2-1
       if storm_temp(t,j,i) .lt. storm_temp(t,j+halp_window*2,i+halp_window*2) .and. \
          storm_temp(t,j,i) .lt. storm_temp(t,j+halp_window*2,i) .and. \
          storm_temp(t,j,i) .lt. storm_temp(t,j+halp_window*2,i-halp_window*2) .and. \
          storm_temp(t,j,i) .lt. storm_temp(t,j,i+halp_window*2) .and. \
          storm_temp(t,j,i) .lt. storm_temp(t,j,i-halp_window*2) .and. \
          storm_temp(t,j,i) .lt. storm_temp(t,j-halp_window*2,i+halp_window*2) .and. \
          storm_temp(t,j,i) .lt. storm_temp(t,j-halp_window*2,i) .and. \
          storm_temp(t,j,i) .lt. storm_temp(t,j-halp_window*2,i-halp_window*2) then
         storm_temp2(t,j,i) = 1
       end if
     end do
   end do
 end do

;;;;;write nc file
storm_temp!0 = "time"
storm_temp!1 = "lat"
storm_temp!2 = "lon"
storm_temp&time = ttt
storm_temp&lat = lat
storm_temp&lon = lon

system("rm -f /mnt/lustre/proj/jhson/SJ/era5/data/Atlantic3_0.25/Atlantic3_storm_"+year(nyr)+".nc")

fout = addfile ("/mnt/lustre/proj/jhson/SJ/era5/data/Atlantic3_0.25/Atlantic3_storm_"+year(nyr)+".nc","c")
setfileoption(fout,"DefineMode",True)

fAtt               = True            ; assign file attributes
fAtt@title         = "To search storm"
fAtt@source_file   =  "hgt at 850 hPa"
fAtt@Conventions   = "None"
fAtt@creation_date = systemfunc ("date")
fileattdef( fout, fAtt )            ; copy file attributes

dimNames = (/"time" , "latitude", "longitude"/)
dimSizes = (/ -1    ,         ny,  nx/)
dimUnlim = (/ True  ,      False,  False/)
filedimdef(fout,dimNames,dimSizes,dimUnlim)

filevardef(fout, "time"    ,"float", (/"time"/))
filevardef(fout, "latitude"  ,"float", (/"latitude"/))
filevardef(fout, "longitude" ,"float", (/"longitude"/))
filevardef(fout, "hgt"  ,"float",(/"time","latitude","longitude"/))
filevardef(fout, "hgt_smoothed"  ,"float",(/"time","latitude","longitude"/))
filevardef(fout, "storm_location"  ,"float",(/"time","latitude","longitude"/))

filevarattdef(fout,"time" ,storm_temp&time)
filevarattdef(fout,"latitude"  ,storm_temp&lat)
filevarattdef(fout,"longitude"  ,storm_temp&lon)
filevarattdef(fout,"hgt" ,storm_temp)
filevarattdef(fout,"hgt_smoothed" ,storm_temp)
filevarattdef(fout,"storm_location" ,storm_temp2)

setfileoption(fout,"DefineMode",False)

fout->time=(/storm_temp&time/)
fout->latitude=(/storm_temp&lat/)
fout->longitude=(/storm_temp&lon/)
fout->hgt=(/hgt(:,:,:)/)
fout->hgt_smoothed=(/storm_temp/)
fout->storm_location=(/storm_temp2/)

;;draw
;  wks = gsn_open_wks("eps","test"+year(nyr)+"_"+mon(nyr))
        res                = True
        res@gsnDraw        = False
        res@gsnFrame       = False
        res@gsnMaximize    = True
        res@tmXTOn         = False
        res@tmYROn         = False
        res@gsnLeftString  = ""
        res@gsnRightString = ""


;;set map;;
        mpres                             = res
        mpres@mpDataSetName               = "Earth..4"
        mpres@mpDataBaseVersion           = "MediumRes"
;        mpres@mpDataBaseVersion           = "LowRes"
        mpres@mpOutlineOn                 = True
;        mpres@mpOutlineSpecifiers         = (/"China:states","Taiwan","Japan:states","South Korea"/)
;        mpres@mpOutlineSpecifiers         = (/"China","Taiwan","Japan","South Korea"/)
        mpres@mpGeophysicalLineThicknessF = 2.5
        mpres@mpNationalLineThicknessF    = 2
        mpres@mpGeophysicalLineColor = "gray30"
;        mpres@mpFillDrawOrder             = "PostDraw"
;        mpres@mpFillOn                    = True
;        mpres@mpFillAreaSpecifiers        = (/"water",       "land" /)
;        mpres@mpSpecifiedFillColors       = (/"deepskyblue2","white"/)
;       mpres@mpSpecifiedFillColors      = (/100,0/)
;        mpres@mpMaskAreaSpecifiers        = (/"China:states","Taiwan","Japan:states","South Korea"/)

  ;mpres@gsnMajorLatSpacing = 2              ; change maj lat tm spacing
  ;mpres@gsnMajorLonSpacing = 2              ; change maj lon tm spacing
  mpres@gsnMajorLatSpacing = 20              ; change maj lat tm spacing
  mpres@gsnMajorLonSpacing = 20              ; change maj lon tm spacing

;;set area;;
        mpres@mpMinLonF                   = -180
        mpres@mpMaxLonF                   = 180
        mpres@mpMinLatF                   = 30
        mpres@mpMaxLatF                   = 90

        ;mpres@mpMinLonF                   = -50
        ;mpres@mpMaxLonF                   = 30
        ;mpres@mpMinLatF                   = 30
        ;mpres@mpMaxLatF                   = 75 

        ;mpres@mpMinLonF                   = -10
        ;mpres@mpMaxLonF                   = 0
        ;mpres@mpMinLatF                   = 52
        ;mpres@mpMaxLatF                   = 57

;;set contour;;
        cnres                             = res
        cnres@cnLevelSelectionMode = "ManualLevels"
;        gsn_define_colormap(wks,"cmp_b2r")

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

;;;plot
;        plot = new(2, graphic)
;        contour = new(2, graphic)
;
;        arr = (/" "," "," "," "," "/)
;        cnres@tiMainString=arr(0)
;        ;cnres@cnLevelSpacingF = 3                      ; set the interval between contours
;        ;cnres@cnMinLevelValF  = 0                 ; set the minimum contour level
;        ;cnres@cnMaxLevelValF  = 33                     ; set the maximum contour level
;        cnres@gsnLeftStringFontHeightF = 0.03
;        cnres@gsnLeftString = " plz"
;        cnres@gsnRightStringFontHeightF = 0.025
;        plot(0)     = gsn_csm_map(wks,mpres)
;        contour(0) = gsn_csm_contour(wks,storm_temp(26-1,:,:),cnres)
;
;        plot(1)     = gsn_csm_map(wks,mpres)
;        contour(1) = gsn_csm_contour(wks,storm_temp2(26-1,:,:),cnres)
;
;        overlay(plot(0),contour(0))
;        overlay(plot(1),contour(1))
;
; panres                     = True
; panres@gsnMaximize         = True             ; maximize the plots
; panres@gsnPanelLabelBar    = True             ; turn on the panel label bar
; panres@gsnPaperOrientation = "auto"       ; make sure the paper orientation is set to portrait
; panres@lbLabelBarOn = False
;
; gsn_panel(wks,plot,(/2,1/),panres)

delete([/hgt,ttt,storm_temp,storm_temp2/])
end do ;nyr
end
