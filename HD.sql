create database SE;
use SE;
############    Total_Revenue     ###############
select * from fact_bookings;
SELECT SUM(revenue_realized) AS Total_Revenue
FROM fact_bookings;

###########    Total Bookings    ################

select * from fact_bookings;
SELECT count(booking_id) AS Total_Bookings
FROM fact_bookings;


##########      Cancellation Rate    #############

SELECT 
    ROUND(COUNT(CASE WHEN booking_status = 'Cancelled' THEN 1 END) * 100.0 / COUNT(*),2)
        AS cancellation_rate_percentage FROM  fact_bookings;
        
        
##########      Occupancy   #############

SELECT 
    ROUND(SUM(successful_bookings) * 100.0 / SUM(capacity),2) AS occupancy_percentage
FROM fact_aggregated_bookings;


##########   Total Capacity   ############

SELECT SUM(capacity) AS Total_Capacity
FROM fact_aggregated_bookings;

#############    Checked out cancel No show     ##################

SELECT *
FROM fact_bookings
WHERE booking_status IN ('Checked Out', 'Cancelled', 'No Show') order by booking_status;


############

SELECT 
    SUM(f.successful_bookings) AS total_revenue
FROM 
    fact_aggregated_bookings f
JOIN 
    dim_date d ON f.check_in_date= d.date_key;

select * from dim_date; 
Alter table dim_date change column `date` date_key varchar(30);
Alter table dim_date change column `mmm yy` mmm_yy varchar(30);
Alter table dim_date change column `week no` week_no varchar(20); 
###################      Weekday  & Weekend  Revenue and Booking  ##################
SELECT 
    d.day_type,
    COUNT(f.booking_id) AS total_bookings,
    SUM(f.revenue_realized) AS total_revenue
FROM 
    fact_bookings f
JOIN 
    dim_date d ON f.check_in_date = d.date_key
GROUP BY 
    d.day_type;
	
    ########   Classwise Revenue ###########
    SELECT 
    dr.room_class,
    SUM(fb.revenue_realized) AS total_revenue
FROM 
    fact_bookings fb
JOIN 
    dim_rooms dr
ON 
    fb.room_category = dr.room_id
WHERE 
    fb.booking_status = 'Checked Out'
GROUP BY 
    dr.room_class;
    
############     City and Hotel Wise Revenue  #########
SELECT 
    h.city AS state,
    h.property_name AS hotel_name,
    SUM(b.revenue_realized) AS total_revenue
FROM 
    fact_bookings b
JOIN 
    dim_hotels h
ON 
    b.property_id = h.property_id
WHERE 
    b.booking_status = 'Checked Out'
GROUP BY 
    h.city, h.property_name
ORDER BY 
    h.city, total_revenue DESC;
#############       Week wise revenue    ###########    
SELECT 
	d.week_no AS week_number,
    SUM(f.revenue_generated) AS total_revenue_generated,
    SUM(f.revenue_realized) AS total_revenue_realized
FROM
    fact_bookings f
JOIN
    dim_date d
    ON f.booking_date = d.date_key
GROUP BY
    d.week_no
ORDER BY
    d.week_no;

#############  Trends analyze   ###############
########   Monthly #########
SELECT
    d.mmm_yy AS month_year,
    SUM(f.revenue_generated) AS total_revenue_generated,
    SUM(f.revenue_realized) AS total_revenue_realized
FROM
    fact_bookings f
JOIN
    dim_date d
    ON f.booking_date = d.date_key
GROUP BY
    d.mmm_yy
ORDER BY
    d.mmm_yy;
#######  Yearly ###########    
SELECT
    YEAR(f.booking_date) AS year,
    SUM(f.revenue_generated) AS total_revenue_generated,
    SUM(f.revenue_realized) AS total_revenue_realized
FROM
    fact_bookings f
GROUP BY
    YEAR(f.booking_date)
ORDER BY
    year;

