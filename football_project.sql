create database football_ticket_booking_system;
--create user table
create table Users (
    user_id serial primary key,
    full_name varchar(100),
    email varchar(100) unique,
    role varchar(50) check (role in ('Ticket Manager', 'Football Fan')),
    phone_number varchar(20)
);
--create matches
create table Matches (
    match_id serial primary key,
    fixture varchar(100),
    tournament_category varchar(100),
    base_ticket_price decimal(10,2) check (base_ticket_price >= 0),
    match_status varchar(50) check (match_status IN
        ('Available', 'Selling Fast', 'Sold Out', 'Postponed'))
);
--create booing 
create table Bookings (
    booking_id serial primary key,
    user_id int references Users(user_id),
    match_id int references Matches(match_id),
    seat_number varchar(20),
    payment_status varchar(50) check (payment_status IN
        ('Pending', 'Confirmed', 'Cancelled', 'Refunded')
        OR payment_status IS NULL),
    total_cost decimal(10,2) check (total_cost >= 0)
);
--INSERT SAMPLE DATA INTO USERS
insert into Users (user_id, full_name, email, role, phone_number) values
(1, 'Tanvir Rahman', 'tanvir@mail.com', 'Football Fan', '+8801711111111'),
(2, 'Asif Haque', 'asif@mail.com', 'Football Fan', '+8801722222222'),
(3, 'Sajjad Rahman', 'sajjad@mail.com', 'Ticket Manager', '+8801733333333'),
(4, 'Jannat Ara', 'jannat@mail.com', 'Football Fan', NULL);
--INSERT SAMPLE DATA INTO MATCHES
insert into Matches (match_id, fixture, tournament_category, base_ticket_price, match_status) values
(101, 'Real Madrid vs Barcelona', 'Champions League', 150.00, 'Available'),
(102, 'Man City vs Liverpool', 'Premier League', 120.00, 'Selling Fast'),
(103, 'Bayern Munich vs PSG', 'Champions League', 130.00, 'Available'),
(104, 'AC Milan vs Inter Milan', 'Serie A', 90.00, 'Sold Out'),
(105, 'Juventus vs Roma', 'Serie A', 80.00, 'Available');

--INSERT SAMPLE DATA INTO BOOKINGS
insert into Bookings (booking_id, user_id, match_id, seat_number, payment_status, total_cost) values
(501, 1, 101, 'A-12', 'Confirmed', 150.00),
(502, 1, 102, 'B-04', 'Confirmed', 120.00),
(503, 2, 101, 'A-13', 'Confirmed', 150.00),
(504, 2, 101, NULL, NULL, 150.00),
(505, 3, 102, 'C-20', 'Pending', 120.00);
--Query 1
select match_id,fixture,base_ticket_price from matches
  where tournament_category='Champions League' and match_status='Available';

--Query 2
select user_id,full_name,email from users
 where full_name like 'Tanvir%' or full_name like '%Haque%';
--Query 3
select booking_id,user_id,match_id,coalesce(payment_status,'Action Required') as systematic_status from bookings
  where payment_status is null;
----Query 4
select b.booking_id,
    u.full_name,
    m.fixture,
    b.seat_number,
    b.payment_status,
    b.total_cost from bookings as b
  inner join users as u
        on b.user_id=u.user_id
  inner join matches as m
        on b.match_id=m.match_id;
--Qurry 5
select u.user_id,
       u.full_name,
       b.booking_id from users as u
  left join bookings as b
          on u.user_id=b.user_id;
--Qurey 6
select * from bookings 
 where total_cost>(select avg(total_cost) from bookings);
--Qurey 7
select * from matches
 order by base_ticket_price desc
 limit 2 offset 1;
