# Methods

## [Database Conversion](https://github.com/dapperstats/salvage/blob/master/documents/conversion.md).

Accessing the remote data, converting the `.accdb` to `.csv` files, and loading the data into R.
Leverages [the `accessor` software](https://www.github.com/dapperstats/accessor). 

## Auto-build

The data are updated daily via [`cron` jobs](https://docs.travis-ci.com/user/cron-jobs/) on [`travis-ci`](https://travis-ci.org/dapperstats/salvage).

