;
; These files are loaded by default in NCL V6.2.0 and newer
; load "$NCARG_ROOT/lib/ncarg/nclscripts/csm/gsn_code.ncl"
; load "$NCARG_ROOT/lib/ncarg/nclscripts/csm/gsn_csm.ncl"
;**************************************************
begin
;**************************************************

year = ispan(1979,2022,1)

do nyr=0, dimsizes(year)-1

f_t = addfile("/mnt/lustre/proj/jhson/SJ/era5/data/Atlantic3_0.25/Atlantic3_storm_"+year(nyr)+".nc","r")
hgt = f_t->hgt
hgt_smoothed = f_t->hgt_smoothed
storm = f_t->storm_location
lon = f_t->longitude
lat = f_t->latitude
ttt = f_t->time

;print(lat)

nx = dimsizes(lon)
ny = dimsizes(lat)
nt  = dimsizes(ttt)
degree = 0.25
number = 1000

;print(nx)
;print(ny)
;print(nz)
;print(nt)

;storm_1 = storm
tracking_1 = new((/nt,number,10/),"float") ;nt=temporal number of storms,
tracking_2 = new((/number,nt,10/),"float") ;nt=temporal number of storms,
tracking_1(:,:,:) = 1.e20
tracking_2(:,:,:) = 1.e20
;tracking = new((/nt,10/),"float",1e20) ;nt=number of storms,
;[0:number, 1:nctime, 2:longitude, 3:latitude, 4:timedimension, 5:duration, 6:year, 7:month, 8:day, 9:hour]
radius = 10  ;10 means 2.5 degree, 20 means 5 degree, 30 means 7.5 degree size of storm
distance = 2.5 ;degree of travel in each time step

;;;;;search storm center
do t = 0, nt-1
  do i = radius, nx-radius-1
    do j = radius, ny-radius-1
      if (storm(t,j,i) .eq. 1) .and. (min(hgt_smoothed(t,j-radius:j+radius,i-radius:i+radius)) .eq. hgt_smoothed(t,j,i)) then
      ;if (storm(t,j,i) .eq. 1) .and. (min(hgt(t,j-radius:j+radius,i-radius:i+radius)) .eq. hgt(t,j,i)) then
        storm(t,j,i) = 100
      end if
    end do
  end do
end do

tn=0
do t = 0, nt-1
n=0
 do i = radius, nx-radius-1
   do j = radius, ny-radius-1
     if storm(t,j,i) .eq. 100 then
     t_temp = ut_calendar(ttt(t),0)

     tracking_1(t,n,0) = n
     tracking_1(t,n,1) = tofloat(ttt(t))
     tracking_1(t,n,2) = tofloat(lon(i))
     tracking_1(t,n,3) = tofloat(lat(j))
     tracking_1(t,n,4) = t
     tracking_1(t,n,5) = 0
     tracking_1(t,n,6) = tofloat(t_temp(0,0))  ;year
     tracking_1(t,n,7) = tofloat(t_temp(0,1))  ;month
     tracking_1(t,n,8) = tofloat(t_temp(0,2))  ;day
     tracking_1(t,n,9) = tofloat(t_temp(0,3))  ;hour
     tn=tn+1
     n=n+1
     end if
   end do ;j
 end do  ;i
end do ;t



print(tn) ;total number of storms detected in the previous step

;;;;;;make trajectory
count=0
  do t = 0, nt-1
  do n = 0, 10-1   ;number of storms occurring at the same time
    if tracking_1(t,n,2) .lt. 1.e20 then
        tracking_2(count,t-t,:) = tracking_1(t,n,:)
        tracking_2(count,t-t,0) = count
        tracking_1(t,n,:) = 1.e20
 
        do t1 = t+1, nt-1
        do n = 0, 10-1  ;number of storms occurring at the same time
          if ((abs(tracking_2(count,t1-t-1,2)-tracking_1(t1,n,2)) .le. distance) .and. (abs(tracking_2(count,t1-t-1,3)-tracking_1(t1,n,3)) .le. distance)) .and. ((abs(tracking_2(count,t1-t-1,2)-tracking_1(t1,n,2)) .le. tracking_2(count,t1-t,2)-tracking_1(t1,n,2)) .and. (abs(tracking_2(count,t1-t-1,3)-tracking_1(t1,n,3)) .le. tracking_2(count,t1-t,2)-tracking_1(t1,n,2))) then
            tracking_2(count,t1-t,:) = tracking_1(t1,n,:)
            tracking_1(t1,n,:) = 1.e20
            if tracking_2(count,t1-t,0) .lt. 1.e20 then
              tracking_2(count,:,5) = t1-t-1
            end if
            tracking_2(count,t1-t,0) = count
          end if
        end do
        end do
        count = count+1
    end if  
  end do ;n
  end do ;number
print(count) ;number of storms


;;;;remove storm shorter then 24 hours
life_hour = 24

number = 0
 do n = 0, count-1
   if tracking_2(n,life_hour,2) .lt. 1.e20 then
     number = number+1
   end if
 end do
print(number)

storm_track = new((/number,nt,10/),"float") ;nt=temporal number of storms,
number = 0
 do n = 0, count-1
   if tracking_2(n,life_hour,2) .lt. 1.e20 then
     storm_track(number,:,:) = tracking_2(n,:,:)
     storm_track(number,:,0) = number
     number = number+1
   end if
 end do

;;;;;write nc file
storm_track!0 = "number"
storm_track!1 = "time"
storm_track!2 = "information"
storm_track&time = ttt
inf = (/"number","nctime","longitude","latitude","timedimension","duration","year","month","day","hour"/)
storm_track&information = inf

system("rm -f /mnt/lustre/proj/jhson/SJ/era5/data/Atlantic3_0.25/Atlantic3_storm_tracking_"+year(nyr)+".nc")
;system("rm -f ../Atlantic3_storm_tracking_"+year(nyr)+".nc")

fout = addfile ("/mnt/lustre/proj/jhson/SJ/era5/data/Atlantic3_0.25/Atlantic3_storm_tracking_"+year(nyr)+".nc","c")
;fout = addfile ("../Atlantic3_storm_tracking_"+year(nyr)+".nc","c")
setfileoption(fout,"DefineMode",True)

fAtt               = True            ; assign file attributes
fAtt@title         = "To search storm"
fAtt@source_file   =  "hgt at 850 hPa"
fAtt@Conventions   = "None"
fAtt@creation_date = systemfunc ("date")
fileattdef( fout, fAtt )            ; copy file attributes

dimNames = (/"number" ,"time" , "latitude", "longitude", "information"/)
dimSizes = (/ number  , nt    ,         ny,          nx,             10/)
dimUnlim = (/ False   , False  ,      False,       False,         False/)
filedimdef(fout,dimNames,dimSizes,dimUnlim)

filevardef(fout, "time"    ,"float", (/"time"/))
filevardef(fout, "latitude"  ,"float", (/"latitude"/))
filevardef(fout, "longitude" ,"float", (/"longitude"/))
filevardef(fout, "storm"  ,"float",(/"time","latitude","longitude"/))
;filevardef(fout, "number"    ,"float", (/"number"/))
;filevardef(fout, "information"  ,"float", (/"information"/))
;filevardef(fout, "storm_track"  ,"float",(/"number","time","information"/))
filevardef(fout, "storm_track"  ,"float",(/"number","time","information"/))

;filevarattdef(fout,"number" ,storm&time)
;filevarattdef(fout,"information"  ,storm&lat)
filevarattdef(fout,"time" ,ttt)
filevarattdef(fout,"latitude"  ,lat)
filevarattdef(fout,"longitude"  ,lon)
filevarattdef(fout,"storm" ,storm)
filevarattdef(fout,"storm_track" ,storm_track)

setfileoption(fout,"DefineMode",False)

fout->time=(/ttt/)
fout->latitude=(/lat/)
fout->longitude=(/lon/)
fout->storm=(/storm/)
fout->storm_track=(/storm_track/)

;;;;;draw
;********************************************
   wks = gsn_open_wks("png","./draw/traj_"+year(nyr))               ; send graphics to PNG file
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

   string_month = (/"January", "February", "March", "April", "May", "June", "July", "August", "September", "October", "November", "December"/)
   ;res@tiMainString    = "TC track generated in "+string_month(month-1)  ; title
   res@tiMainString    = "Atlantic storms" ;title
   res@gsnCenterString = "("+toint(t_temp(0,0))+")"   ; center string

   res@mpDataBaseVersion     = "MediumRes"               ; better map outlines
   res@pmTickMarkDisplayMode = "Always"                  ; better map tickmarks

   ;map = gsn_csm_map_ce(wks,res)                         ; create map
   map = gsn_csm_map(wks,res)                         ; create map
;*********************************************
; trajectory parameters
;*********************************************
   ;traj = ispan(0,sdims[1]-1,1)
   ;year = ispan(0,40,1)
   ;year = ispan(0,2,1)
;*********************************************
; some plot parameters
;*********************************************
   pres                  = True               ; polyline resources
   pres@gsLineThicknessF = 2.0                ; line thickness

   mres  = True                               ; marker resources
   first = True                               ; start of traj resources
   second = True                               ; start of traj resources

   first@gsMarkerIndex  = 16           ; marker style (circle)
   first@gsMarkerSizeF  = 8.0         ; marker size
   first@gsMarkerColor  = "blue"     ; marker color

   second@gsMarkerIndex  = 16           ; marker style (circle)
   second@gsMarkerSizeF  = 4.0         ; marker size
   second@gsMarkerColor  = "black"     ; marker color

   draw(map)
;********************for trajectory************
       pres@gsLineColor = "black"            ; line color for this traj
     do n = 0, number -1
       xpt = new((/tolong(storm_track(n,0,5))/),"float") 
       ypt = new((/tolong(storm_track(n,0,5))/),"float") 
       xpt(:) = storm_track(n,0:tolong(storm_track(n,0,5))-1,2)
       ypt(:) = storm_track(n,0:tolong(storm_track(n,0,5))-1,3)
       ;print(xpt)
       ;print(ypt)
       gsn_polyline(wks,map,xpt,ypt,pres)      ; draw the traj
       gsn_polymarker(wks,map,xpt(0),ypt(0),first) ; draw start of traj
       gsn_polymarker(wks,map,xpt(tolong(storm_track(n,0,5))-1),ypt(tolong(storm_track(n,0,5))-1),second) ; draw start of traj
       
       delete([/xpt,ypt/]) 
     end do
   frame(wks)
delete([/hgt,ttt,hgt_smoothed,storm,storm_track,tracking_1,tracking_2/])
end do ;nyr
end
