# require 'rubygems'
require 'sqlite3'

db = SQLite3::Database.open('./Chinook_Sqlite.sqlite')
db.results_as_hash = true
p "1.) CUSTOMERS NOT FROM USA"
p db.execute("select c.customerid 'Customer Id', c.FirstName 'First Name', c.lastname 'Last Name', c.country 'COUNTRY'
from customer c where c.country != 'USA' ")

p "2.) CUSTOMERS FROM BRAZIL"
p db.execute("select * from customer c where c.country == 'Brazil'")

p "3.) CUSTOMERS' INVOICES FROM BRAZIL"
p db.execute("select c.firstname 'First Name', c.lastname 'Last Name', i.invoiceid 'Invoice Id', i.invoicedate 'Invoice Date'
from customer c, invoice i where c.customerId = i.customerid and c.country =='Brazil'")

p "4.) EMPLOYEES WHO ARE SALES AGENTS"
p db.execute("select * from employee e where e.title like '%agent'")

p "5.) unique/distinct list of billing countries".upcase
p db.execute("select distinct i.billingcountry from invoice i")

p "6.) SALES AGENT INVOICES"
p db.execute("select e.lastname 'Last Name', e.firstname 'First Name', i.invoiceid 'invoice' from employee e, customer c, invoice i where c.customerid == i.customerid and c.supportrepid == e.employeeid ").length


p "7.) SALES AGENT INVOICES"
p db.execute("select e.lastname 'Agent Last Name', e.firstname 'Agent First Name',
c.lastname 'Customer Last Name', c.firstname 'Customer First Name',
i.total 'invoice', i.BillingCountry from employee e, customer c, invoice i where c.customerid == i.customerid and c.supportrepid == e.employeeid ").length

p "8.) Invoices were there in 2009 and 2011".upcase
p db.execute("select i.invoiceid, strftime('%Y', i.invoicedate) 'Year', count(*) from invoice i where strftime('%Y', i.invoicedate) = '2009' or strftime('%Y', i.invoicedate) = '2011' group by strftime('%Y', i.invoicedate)")

p "9.) Total Sales in 2009 and 2011".upcase
p db.execute("select sum(i.total) 'Total Sales', strftime('%Y', i.invoicedate) 'Year', count(*) from invoice i where strftime('%Y', i.invoicedate) = '2009' or strftime('%Y', i.invoicedate) = '2011' group by strftime('%Y', i.invoicedate)")

p "10.) Item Count for InvoiceId 37".upcase
p db.execute("select count(*) 'Number' from invoiceline il where il.invoiceid == '37'")

p "11.) Item Count for Each InvoiceId".upcase
p db.execute("select il.invoiceid 'invoiceid', count(*) 'Number' from invoiceline il group by il.invoiceid ")

p "12.) Purchased Track Name With Each Purchase".upcase
p db.execute("select il.invoicelineid 'invoicelineid', t.name 'Track Name' from invoiceline il, track t where il.trackid == t.trackid order by InvoiceLineid ")

p "13.) Purchased Track Name With Artist Name for Each Purchase".upcase
p db.execute("select il.invoicelineid 'invoicelineid', t.name 'Track Name', a.name 'Artist Name' from invoiceline il, track t, artist a, album al where il.trackid == t.trackid and al.artistid == a.artistid and t.albumid == al.albumid order by il.invoicelineid")

p "14.) Number of Invoices Per Country".upcase
p db.execute("select i.billingcountry, count(*) 'Number' from invoice i  group by i.billingcountry")

p "15.) Total Number of Tracks in Each Playlist".upcase
p db.execute("select p.playlistid 'Playlist Id', pl.name 'Playlist Name', count(*) 'Number' from playlisttrack p, playlist pl where p.playlistid == pl.playlistid group by p.playlistid")


p "16.) Shows All Tracks With Album Name, Media Type, Genre Without Id".upcase
p db.execute("select t.name 'Track Name', al.title 'Album Title', m.name 'Media Type', g.name from track t, album al, mediatype m, genre g where t.albumid = al.albumid and t.mediatypeid = m.mediatypeid and t.genreid = g.genreid ")

p "17.) Shows All Invoices but Includes # Of Invoice Line Items".upcase
p db.execute("select i.*, count(*) 'Number of InvoiceLineItems' from invoice i, invoiceline il where i.invoiceid = il.invoiceid group by i.invoiceid")


p "18.) Total Sales By Each Sales Agent".upcase
p db.execute("select e.employeeid, e.lastname, e.firstname, sum(i.total) 'Total Sales'  from employee e, invoice i, customer c where e.employeeid = c.supportrepid and i.customerid = c.customerid group by e.employeeid")

p "19.) Highest Sales Agent in 2009".upcase
# p db.execute("select e.employeeid, e.lastname, e.firstname, total(i.total) 'Total Sales'  from employee e, invoice i, customer c where e.employeeid = c.supportrepid and i.customerid = c.customerid and strftime('%Y', i.InvoiceDate) = '2009' group by e.employeeid order by total(i.total) desc limit 1")

p db.execute("select Max(totals),id,first,name from (select e.employeeid 'id', e.lastname 'name', e.firstname 'first', total(i.total) 'Totals'  from employee e, invoice i, customer c where e.employeeid = c.supportrepid and i.customerid = c.customerid and strftime('%Y', i.InvoiceDate) = '2009' group by e.employeeid)")

p "20.) Highest Sales Agent Overall".upcase
p db.execute("select Max(totals),id,first,name from (select e.employeeid 'id', e.lastname 'name', e.firstname 'first', total(i.total) 'Totals'  from employee e, invoice i, customer c where e.employeeid = c.supportrepid and i.customerid = c.customerid group by e.employeeid)")

p "21.) Customers Assigned to Each Sales Agent".upcase
p db.execute("select e.lastname, e.firstname, count(*) 'Number of Clients' from employee e, customer c where c.supportrepid = e.employeeid group by e.employeeid")

p "22.) Total Sales Per Country".upcase
p db.execute("select i.billingcountry, sum(i.total) 'Total Sales' from invoice i group by i.billingcountry")

p "23.) Total Sales Per Country".upcase
p db.execute("select Max(Total_Sales) 'Max Sales', Country from (select i.billingcountry 'Country', sum(i.total) 'Total_Sales' from invoice i group by i.billingcountry)")

p "24.) Most Purchased Track in 2013".upcase
p db.execute("select MAx(Purchasesin2013) 'Max Purchases' ,Name from (select t.name 'Name', count(*) 'Purchasesin2013' from track t, invoice i, invoiceline il where i.invoicedate like "2013%" and il.trackid = t.trackid and i.invoiceid = il.invoiceid group by t.name)")

p "25.) Top 5 Most Purchased Tracks Overall".upcase
p db.execute("select t.name 'Name', count(*) 'Purchases' from track t, invoice i, invoiceline il where il.trackid = t.trackid and i.invoiceid = il.invoiceid group by t.trackid order by count(*) desc limit 5")

p "26.) Top 3 Selling artists".upcase
p db.execute("select a.name 'Name', sum(i.total) 'Sales' from artist a, invoiceline il,invoice i, track t, album al where il.trackid = t.trackid and t.albumid = al.albumid and al.artistid = a.artistid group by a.artistid order by sum(i.total) desc limit 3")

p "27.) Most Purchased Media Type".upcase
p db.execute("select  Name, MAX(Sales) 'Sales' from (select m.name 'Name', count(*) 'Sales' from mediatype m, invoiceline il, track t where il.trackid = t.trackid and t.mediatypeid = m.mediatypeid group by m.name)")