/*
Are all accounts contributing equally to cash flow stability?

Does one account subsidize another?

Are any accounts structurally unprofitable?
*/

select sum(amount) as cash, account
from income
group by account
order by cash desc;

select sum(amount) as cash, account
from expenses
group by account
order by cash desc;

/* 
I can see that not all accounts are contributing equally, or even near equally to cash flow.
Account 1 has the most cash flow, generally, with a significant amount of revenue also going to account 2. 
However, on the expense sheet, it is abundantly clear that most transactions / flow occurs out of the account 1.
There are accounts, 2 and 3, have recorded expenses, but accounts 4 and 5, which gain some fractions of total income, are likely savings funds / ememrgency funds.

It also appears that account three has a sum recorded income of about 64 USD, but expense wise, outputs 1354 USD. There is likely subsidization from accounts (probably account 2)
Account 3 is also structually unprofitable, as there is always a lower income for that account, compared to expense. This account always needs to be subsidized, at least in the year I am assessing.
It would need subsidization from another account, likely account 1 and 2, to exist. 
The cause for the use of this account is unknown.
*/



