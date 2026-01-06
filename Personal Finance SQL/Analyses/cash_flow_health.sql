/*
On a monthly basis, is net cash flow consistently positive, negative, or unstable?

How often does net cash flow turn negative, and are those periods clustered or isolated?

Are recent months improving or deteriorating compared to earlier periods?

Does short-term volatility obscure a longer-term trend?
*/

-- combine expenses and income sheets
WITH transactions AS(
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




-- On a monthly basis, is net cash flow consistently positive, negative, or unstable?

SELECT extract(month from date_time) as month, sum(amount) as monthly_net_gain
FROM transactions
GROUP BY month
ORDER BY month

/*
On a monthly basis, cashflow is generally positive, with the exception of the month of march, when the client incurred a loss of 199 BYT. 
Cashflow rarely turns negative, with the only net-negative month being March, with a deficit of 199 BYT. These periods appear to generally be isolated
when judging on a month-month basis.
Recent months show consistently positive balances in the user's accounts, overall.
However, there are two stark drops in the amount remaining in the user's account after September ends. 
This indicates the start of a high spending period from October onward, possibly due to end-of-year bill payments and holiday spending.
Short term volatility does not obscure a long term trend of positive monthly figures in the individual's bank account. This is important because
if examining only the first 3-4 months, post-expenses, the negative net-gain in March may seem like a sign of concern.
However, observing the dataset as a whole, for all 11 months, it is clear that the trend does not sustain. 

*/

