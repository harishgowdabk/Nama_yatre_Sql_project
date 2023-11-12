
#TOTAL TRIPS
select count(*) from trips;

select count(*) from trips_details4;#( includes trip_id just searched and not ended)

select count(*) 
from trips_details4
WHERE  end_ride=1;

# TO CHECK IF ANY DUPLICATE Tripid is present

select tripid ,count(tripid) as count
from trips_details4
group by tripid
having count > 1 ;


#TOTAL DRIVERS

SELECT COUNT(distinct driverid) as TOTAL_DRIVERS from trips

#TOTAL EARNINGS
SELECT SUM(fare) from trips;

## TOTAL COMPLETED TRIPS

SELECT COUNT( DISTINCT tripid)
FROM trips;

#TOTAL SEARCHES
select SUM(searches) as searches from trips_details4;

#TOTAL SEARCHES WHICH GOT ESTIMATE
select SUM(searches) as searches
 from trips_details4
 WHERE searches_got_estimate = 1;                #1758
 
 #TOTAL SEARCHES FOR QUOTES
select SUM(searches_for_quotes) as searches
 from trips_details4;    #1455
 
 #TOTAL DRIVER CANCELED
 
 SELECT count(driver_not_cancelled) as driver_cancels
 from trips_details4
 where driver_not_cancelled = 0;                         #1021
 
 #or
 
 select count(*) - sum(driver_not_cancelled) as driver_cancels
 from trips_details4;                                              #1021
 
 
 #TOTAL OTP ENTERED
 select sum(otp_entered) as searches
 from trips_details4;                                              #983
 
 #Average distance from trips
 
 SELECT AVG(distance) as avg_distance
 from trips;
 
 #Average Fare per Trip
 
 SELECT round(AVG(fare),2) as avg_fare
 from trips;                                                        #764.3367 or 764.34
 
 #DISTANCE TRAVELLED
 
 select sum(distance)
 from trips;                                                       #14148
 
 
 #which is the most used payment method
 
 SELECT a.method,b.COUNT
 from payment a
 inner join 
 
 (SELECT  faremethod,COUNT(faremethod) as count
 from trips
 group by faremethod
 order by count desc) b
 on a.id = b.faremethod
 order by count desc
 limit 1;                              #4--> 262
 
 
 # THE HIGHEST PAYMENT WAS MADE THROUGH WHICH INSTRUMENT
 select faremethod, sum(fare) from trips
 group by faremethod
 order by sum(fare) desc;
 
 
 #which two locations had the most number of trips


SELECT *
FROM (
    SELECT *, DENSE_RANK() OVER (ORDER BY count DESC) AS rnk
    FROM (
        SELECT loc_from, loc_to, COUNT(DISTINCT tripid) AS count
        FROM trips
        GROUP BY loc_from, loc_to
    ) a
) b
WHERE rnk = 1;



#top 5 earning drivers



SELECT *
FROM (
    SELECT *, DENSE_RANK() OVER (ORDER BY total DESC) AS rnk
    FROM (
        SELECT driverid, SUM(fare) AS total
        FROM trips
        GROUP BY driverid
    ) b
) c
WHERE rnk < 6;

# which duration had the most number of trips


select * from
(select *,rank() over (order by count desc) as rnk from
(select duration,count(duration) as count from trips
group by duration
order by count desc)b)c
where rnk=1;


#which driver,customer pair had more orders
select * from
(
select *,dense_rank() over (order by count desc) as rnk from
(
select driverid,custid,count(distinct tripid)count from trips
group by driverid,custid
order by count desc
)b
   )c
where rnk =1;                                             #driver:- 17,96
 
 #search  to estimate rate
 
 select sum(searches_got_estimate)*100/ sum(searches) as percentage
 from trips_details4;
 
 
 #estimate to search for quote rates
 
 
 #which area got highest trips in which duration
 select *
 from(
 select *, rank()over(partition by duration order by count desc) rnk 
 from
(select loc_from,duration,count(distinct tripid) as count
 from trips
 group by duration,loc_from
 )a
	)c
 order by count desc;
 
 

 
  select *
 from(
 select *, rank()over(partition by loc_from order by count desc) rnk 
 from
(select loc_from,duration,count(distinct tripid) as count
 from trips
 group by duration,loc_from
 )a
	)c
 order by count desc;
 
 
 
  #which area got the highest fares, cancellation ,trips
 
 select * from trips;
 select * from trips_details;
 
 select * from
 (select * ,rank() over(order by total desc) as rnk
 from
 (select loc_from,sum(fare) as total
 from trips
 group by loc_from)b)c
 where rnk=1;
 
 
  select * from
 (select * ,rank() over(order by total_canceled desc) as rnk
 from
 (select loc_from,count(*) - sum(driver_not_cancelled) as total_canceled
 from trips_details4
 group by loc_from)b)c
 where rnk=1;
 
  select * from
 (select * ,rank() over(order by total_canceled desc) as rnk
 from
 (select loc_from,count(*) - sum(customer_not_cancelled) as total_canceled
 from trips_details4
 group by loc_from)b)c
 where rnk=1;