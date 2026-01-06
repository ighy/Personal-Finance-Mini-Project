/*
What percentage of total months show expenses exceeding income?

Are expense increases driven by rising spend, falling income, or both?

Does income growth (if any) keep pace with expense growth over time?

Are there structural imbalances between inflows and outflows?
*/

WITH cashflow AS(
select 
    date_time,
    category,
    account,
    amount,
    currency,
    tags,
    'income' as source


from income

UNION ALL

select 
    date_time,
    category,
    account,
    amount * -1,
    currency,
    tags,
    'expense' as source

from expenses
)
select ((count(month)* 1.0) / 11) * 100 as percent_negative_months from(
select sum(amount) as net_gain, EXTRACT(MONTH from date_time) as month
from cashflow
GROUP BY MONTH
)
where net_gain < 0;
-- in only march does the expense sum appear greater than the income sum, therefore, about 9.1% of months have the expenses summing to be greater than the income.


-- Are expense increases driven by rising spend, falling income, or both?
with income_table as(
select sum(amount) as amounts, EXTRACT(MONTH from date_time) as month
from income
group by month
order by month asc
),
expense_table as(
select sum(amount) as amounts, EXTRACT(MONTH from date_time) as month
from expenses
group by month
order by month asc
)


select * from expense_table;
-- there was a high expense, but also a high income in the month of march, where a net loss in the personal finance account was logged.
-- let us investigate this further.

select * from expenses 
where extract(MONTH from date_time) = 3
order by amount desc;
-- there is loaned amount of 1172 BYT, which is atypical for any month.
-- furthermore, there is a 1156 BYT charge for 'other', which is also atypical. this indicates a outlier in spending, which may be correlated to income. lets check

select * from income 
where extract(MONTH from date_time) = 3
order by amount desc;
-- what allows this month to also stand out in terms of income, is likely that the person knew of the outlier spending that would be happening, and thus, clocked a 2nd highest paycheck amount from the 2nd job, as well as gained money from the returning of a debt, along with "other"
-- lets rank the income from 2nd work to see if this may have been planned
select sum(amount) as money_in, EXTRACT(month from date_time) as months from income 
where category = 'Second work'
GROUP BY months
order by money_in desc;
-- the month of march is near the middle, so it doesn't seem like the extra effort at the second job was due to knowing the high-amount of spending in march
-- lets order the main job incomes to see if there was effort on that part
select sum(amount) as money_in, EXTRACT(month from date_time) as months from income 
where category = 'Job'
GROUP BY months
order by money_in desc;
-- same thing here.

-- now lets rank categories by income generated in march
select category, sum(amount) as amounts
from income
where EXTRACT(month from date_time) = 3
GROUP BY category
order by amounts desc;

-- the main income rise is due to the two confounding variables, debt returned and other, as they differ greatly in march, compared to the other months


