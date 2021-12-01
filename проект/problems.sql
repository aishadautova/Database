--4

-- Show sales trends for various brands over the past 3 years, by year, month, week.
-- Then break these data out by gender of the buyer and then by income range.

--year
select mod_name, brand_name, year, count(mod_name) from (
                                                            select mod_name, brands.brand_name, extract(year from date) as year
                                                            from deal_purchase,
                                                                 vehicles,
                                                                 models,
                                                                 brands
                                                            where deal_purchase.VIN = vehicles.vin
                                                              and vehicles.mod_id = models.mod_id
                                                              and models.brand_name = brands.brand_name
                                                        ) as result0
where brand_name = 'Bentley' --Audi Bentley Bugatti Lamborghini SEAT Skoda Volkswagen
group by mod_name, brand_name, year
order by year;
--month
select mod_name, brand_name, year, month, count(mod_name) from (
                                                                   select mod_name,
                                                                          brands.brand_name,
                                                                          extract(month from date) as month,
                                                                          extract(year from date)  as year
                                                                   from deal_purchase,
                                                                        vehicles,
                                                                        models,
                                                                        brands
                                                                   where deal_purchase.VIN = vehicles.vin
                                                                     and vehicles.mod_id = models.mod_id
                                                                     and models.brand_name = brands.brand_name
                                                               ) as result0
where brand_name = 'Bentley' --Audi Bentley Bugatti Lamborghini SEAT Skoda Volkswagen
group by mod_name, brand_name, year, month
order by year;
--week
select mod_name, brand_name, year, week, count(mod_name) from (
                                                                   select mod_name,
                                                                          brands.brand_name,
                                                                          --extract(month from date) as month,
                                                                          extract(year from date)  as year,
                                                                          extract(week from date) as week
                                                                   from deal_purchase,
                                                                        vehicles,
                                                                        models,
                                                                        brands
                                                                   where deal_purchase.VIN = vehicles.vin
                                                                     and vehicles.mod_id = models.mod_id
                                                                     and models.brand_name = brands.brand_name
                                                               ) as result0
where brand_name = 'Bentley' --Audi Bentley Bugatti Lamborghini SEAT Skoda Volkswagen
group by mod_name, brand_name, year, week
order by year;

--gender. 1st - all, 2nd - Female/Male
select mod_name, brand_name, year, gender, count(mod_name) from (
                                                                  select mod_name,
                                                                         brands.brand_name,
                                                                         --extract(month from date) as month,
                                                                         extract(year from date) as year,
                                                                         gender
                                                                  from orders,
                                                                       vehicles,
                                                                       models,
                                                                       brands,
                                                                       individual_buyer
                                                                  where orders.VIN = vehicles.vin
                                                                    and vehicles.mod_id = models.mod_id
                                                                    and models.brand_name = brands.brand_name
                                                                    and orders.cus_id = individual_buyer.cus_id
                                                              ) as result0
--where brand_name = 'Bentley' --Audi Bentley Bugatti Lamborghini SEAT Skoda Volkswagen
group by mod_name, brand_name, year, gender
order by gender;

select mod_name, brand_name, year, gender, count(brand_name) from (
                                                            select brands.brand_name,
                                                                   mod_name,
                                                                   extract(year from date) as year,
                                                                   gender
                                                            from orders,
                                                                 vehicles,
                                                                 models,
                                                                 brands,
                                                                 individual_buyer
                                                            where orders.VIN = vehicles.vin
                                                              and vehicles.mod_id = models.mod_id
                                                              and models.brand_name = brands.brand_name
                                                              and orders.cus_id = individual_buyer.cus_id
                                                        ) as result0
--where brand_name = 'Bentley' --Audi Bentley Bugatti Lamborghini SEAT Skoda Volkswagen
where gender = 'Female'
group by mod_name, brand_name, year, gender
order by gender;

--income
select mod_name, brand_name, year, /*cus_income, */count(brand_name) from (
                                                       select mod_name,
                                                              brands.brand_name,
                                                              extract(year from date) as year,
                                                              income                  as cus_income
                                                       from orders,
                                                            vehicles,
                                                            models,
                                                            brands,
                                                            individual_buyer
                                                       where orders.VIN = vehicles.vin
                                                         and vehicles.mod_id = models.mod_id
                                                         and models.brand_name = brands.brand_name
                                                         and orders.cus_id = individual_buyer.cus_id
                                                   ) as result0
--where brand_name = 'Bentley' --Audi Bentley Bugatti Lamborghini SEAT Skoda Volkswagen
where cus_income > 70000 and cus_income < 250000
group by mod_name, brand_name, year--, cus_income
order by year;






-- Suppose that it is found that transmissions made by supplier Getrag between two given dates are defective.
-- Find the VIN of each car containing such a transmission and the customer to which it was sold.
-- If your design allows, suppose the defective transmissions all come from only one of Getrag’s plants

select sup_name, part_name, part_id, date, VIN, cus_id from (
                                                                select orders.VIN,
                                                                       cus_id,
                                                                       suppliers.date as date,
                                                                       sup_name,
                                                                       suppliers.part_id,
                                                                       part_name
                                                                from orders,
                                                                     assemble_cars,
                                                                     suppliers
                                                                where orders.VIN = assemble_cars.VIN
                                                                  and assemble_cars.part_id = suppliers.part_id
                                                            )as result5
where sup_name = 'Getrag' and part_name = 'transmission'
and date >= '2020-04-14' and date < '2021-01-16';







--Find the top 2 brands by dollar-amount sold in the past year.
select brand_name, sum(cost) as sum from (
                                             select extract(year from deal_purchase.date) as date,
                                                    brands.brand_name                     as brand_name,
                                                    cost
                                             from deal_purchase,
                                                  vehicles,
                                                  models,
                                                  brands
                                             where deal_purchase.VIN = vehicles.vin
                                               and vehicles.mod_id = models.mod_id
                                               and models.brand_name = brands.brand_name
                                         )as result1
where date = '2021'
group by brand_name
order by sum(cost) desc limit 2;





-- Find the top 2 brands by unit sales in the past year.
select brand_name, count(*) as cnt from (
                                            select extract(year from deal_purchase.date) as date,
                                                   brands.brand_name                     as brand_name
                                            from deal_purchase,
                                                 vehicles,
                                                 models,
                                                 brands
                                            where deal_purchase.VIN = vehicles.VIN
                                              and vehicles.mod_id = models.mod_id
                                              and models.brand_name = brands.brand_name
                                        ) as result
where date = '2021'
group by brand_name
order by count(*) desc limit 2;




--In what month(s) do convertibles sell best?
--There are no convertibles, so model sales by month
select mod_name, month, count(*) as cnt from (
                                                 select mod_name, extract(month from deal_purchase.date) as month
                                                 from deal_purchase,
                                                      vehicles,
                                                      models
                                                 where deal_purchase.VIN = vehicles.vin
                                                   and vehicles.mod_id = models.mod_id
                                             ) as result31
where mod_name = 'Audi A3' --'Audi A1' 'Audi A3' 'Audi Q7' Ateca Alhambra Leon Golf Caddy Passat Citigo Rapid Scala Centenario
group by mod_name, month
order by cnt desc;

--And brand sales by month
select brand_name, month, count(*) as cnt from (
                                                   select brand_name, extract(month from deal_purchase.date) as month
                                                   from deal_purchase,
                                                        vehicles,
                                                        models
                                                   where deal_purchase.VIN = vehicles.vin
                                                     and vehicles.mod_id = models.mod_id
                                               ) as result32
where brand_name = 'Bentley'   -- Audi Bentley Bugatti Lamborghini SEAT Skoda Volkswagen
group by brand_name, month
order by cnt desc;





--Find those dealers who keep a vehicle in inventory for the longest average time

select dealer_id, round(avg(days)) from (
--продынные
                  select (orders.date - deal_purchase.date) as days, deal_purchase.dealer_id
                  from deal_purchase,
                       orders
                  where orders.vin = deal_purchase.vin
union all
--еще на складе
                  select (current_date - deal_purchase.date) as days, deal_purchase.dealer_id
                  from deal_purchase
                           left join orders o on deal_purchase.vin = o.vin
                  where o.vin is null
              ) as result10
group by dealer_id
order by avg(days) desc;





