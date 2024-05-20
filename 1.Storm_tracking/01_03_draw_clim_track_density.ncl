;
; These files are loaded by default in NCL V6.2.0 and newer
; load "$NCARG_ROOT/lib/ncarg/nclscripts/csm/gsn_code.ncl"
; load "$NCARG_ROOT/lib/ncarg/nclscripts/csm/gsn_csm.ncl"
;**************************************************
begin
;**************************************************

f_t = addfile ("/mnt/lustre/proj/jhson/SJ/era5/data/Atlantic3_0.25/Atlantic3_storm_track_density_1979_2022.nc","r")
storm_Jan = f_t->storm_Jan
storm_Feb = f_t->storm_Feb
storm_Oct = f_t->storm_Oct
storm_Nov = f_t->storm_Nov
storm_Dec = f_t->storm_Dec

count_Jan = f_t->count_Jan
count_Feb = f_t->count_Feb
count_Oct = f_t->count_Oct
count_Nov = f_t->count_Nov
count_Dec = f_t->count_Dec

lon = f_t->longitude
lat = f_t->latitude
ttt = f_t->year

;;;;;draw
;********************************************
   wks = gsn_open_wks("png","./draw/track_density")
   res            = True                          ; map resources
   res@gsnMaximize= True         ; make ps, pdf, eps, .. large
   res@gsnDraw    = False                         ; don't draw
   res@gsnFrame   = False                         ; don't advance frame
   res@vpWidthF   = 0.80                          ; make map bigger
   res@vpHeightF  = 0.80
   ;res@trGridType = "TriangularMesh"

   mpres = res

   mpres@mpDataSetName               = "Earth..4"
   mpres@mpDataBaseVersion           = "MediumRes"
;  mpres@mpDataBaseVersion           = "LowRes"
   mpres@mpOutlineOn                 = True
;  mpres@mpOutlineSpecifiers         = (/"China:states","Taiwan","Japan:states","South Korea"/)
;  mpres@mpOutlineSpecifiers         = (/"China","Taiwan","Japan","South Korea"/)
   mpres@mpGeophysicalLineThicknessF = 2.5
   mpres@mpNationalLineThicknessF    = 2
   mpres@mpGeophysicalLineColor = "gray30"
;  mpres@mpFillDrawOrder             = "PostDraw"
;  mpres@mpFillOn                    = True
;  mpres@mpFillAreaSpecifiers        = (/"water",       "land" /)
;  mpres@mpSpecifiedFillColors       = (/"deepskyblue2","white"/)
;  mpres@mpSpecifiedFillColors      = (/100,0/)
   mpres@mpMaskAreaSpecifiers        = (/"China:states","Taiwan","Japan:states","South Korea"/)

   ;mpres@mpMaxLatF  = 75                           ; select subregion
   ;mpres@mpMinLatF  = 25
   ;mpres@mpMinLonF  = -80
   ;mpres@mpMaxLonF  = 30

   mpres@mpMaxLatF  = 70                           ; select subregion
   mpres@mpMinLatF  = 30
   mpres@mpMinLonF  = -75
   mpres@mpMaxLonF  = 25

   mpres@gsnMajorLatSpacing = 10              ; change maj lat tm spacing
   mpres@gsnMajorLonSpacing = 10              ; change maj lon tm spacing

   mpres@mpDataBaseVersion     = "MediumRes"               ; better map outlines
   mpres@pmTickMarkDisplayMode = "Always"                  ; better map tickmarks

;;set contour;;
   cnres                             = res
   cnres@cnLevelSelectionMode = "ManualLevels"
   ;gsn_define_colormap(wks,"cmp_b2r")
   ;gsn_define_colormap(wks,"cmocean_deep")

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
   cnres@cnFillPalette        = "cmocean_dense"

;   cnres@tiMainString    = "Atlantic storms" ;title

   cnres@cnLevelSpacingF = 5                      ; set the interval between contours
   cnres@cnMinLevelValF  = 0                 ; set the minimum contour level
   cnres@cnMaxLevelValF  = 35                     ; set the maximum contour level

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

   winter = (Jan+Feb+Oct+Nov+Dec)/5.

   winter!0 = "lat"
   winter!1 = "lon"
   winter&lat = lat
   winter&lon = lon

   plot = new(6, graphic)
   contour = new(6, graphic)

   plot(0)     = gsn_csm_map(wks,mpres)
   plot(1)     = gsn_csm_map(wks,mpres)
   plot(2)     = gsn_csm_map(wks,mpres)
   plot(3)     = gsn_csm_map(wks,mpres)
   plot(4)     = gsn_csm_map(wks,mpres)
   plot(5)     = gsn_csm_map(wks,mpres)

   cnres@tiMainString = "October 1979-2022"   ; center string
   contour(0) = gsn_csm_contour(wks,Oct(:,:),cnres)

   cnres@tiMainString = "November 1979-2022"   ; center string
   contour(1) = gsn_csm_contour(wks,Nov(:,:),cnres)

   cnres@tiMainString = "December 1979-2022"   ; center string
   contour(2) = gsn_csm_contour(wks,Dec(:,:),cnres)

   cnres@tiMainString = "January 1979-2022"   ; center string
   contour(3) = gsn_csm_contour(wks,Jan(:,:),cnres)

   cnres@tiMainString = "February 1979-2022"   ; center string
   contour(4) = gsn_csm_contour(wks,Feb(:,:),cnres)

   cnres@tiMainString = "Oct-Feb 1979-2022"   ; center string
   contour(5) = gsn_csm_contour(wks,winter(:,:),cnres)

   overlay(plot(0),contour(0))
   overlay(plot(1),contour(1))
   overlay(plot(2),contour(2))
   overlay(plot(3),contour(3))
   overlay(plot(4),contour(4))
   overlay(plot(5),contour(5))

 panres                     = True
 panres@gsnMaximize         = True             ; maximize the plots
 panres@gsnPanelLabelBar    = True             ; turn on the panel label bar
 panres@gsnPaperOrientation = "auto"       ; make sure the paper orientation is set to portrait
 panres@lbLabelBarOn = False

 gsn_panel(wks,plot,(/3,2/),panres)

 ;frame(wks)
end
