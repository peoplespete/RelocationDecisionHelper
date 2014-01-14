# Relocation Decision Helper

This app will use public data to help users decide where to move from a database featuring information about the different places.

## Elevator Pitch

Imagine this...you've just graduated from something (high school, college, etc) and need to choose a place to live.  You have several requirements: large city, low-priced real estate, etc.  This command line program will ask you a few questions and then provide you with a few recommendations of places that may be a good fit for you.


## Project Requirements

  * Simple feature set
  * CRUD
  * Evidence of effective database querying using a SQL database

## Feature List:

   * I can enter preferences for a place to live
   * I can view recommendations for places I may want to live
   * I can change my preferences to view alternate recommendations.

## Interesting Query:

Figuring out the most cost effective (low cost of living, high wage) and least cost effective (high cost of living, low wage) places to live.

## Data Source:

C2ER, Arlington, VA, ACCRA Cost of Living Index, Annual Average 2010. (http://www.infoplease.com/business/economy/cost-living-index-us-cities.html)

```
Urban Area  100% Composite Index  13 % Grocery Items  29 % Housing  10% Utilities 12 % Transportation 4% Health Care  32 % Miscellaneous Goods and Services
Anniston-Calhoun, County, AL  91.2  101.2 74.8  111.2 88.8  89.3  96.6
Akron OH  100.2 105.1 99.7  107.9 107.1 86.8  96.0
Albany, GA  90.1  108.7 74.8  82.0  96.6  89.8  96.8
Albany, NY  108.1 105.0 112.6 101.0 102.8 111.7 108.6
```

Census API (http://www.census.gov/developers/)

```
{
  "get": [
    "P0010001",
    "P0030001"],
  "fips": [
    {
      "name": "state",
      "exampleValue": "06",
      "geoLevelId": "040"
    },
    {
      "name": "county",
      "exampleValue": "001",
      "geoLevelId": "050",
      "in": [
        {
          "name": "state",
          "example-value": "06",
          "isOptionalWithWCFor": "true"
        }
      ]
    },
    {
      "name": "county subdivision",
      "exampleValue": "86690",
```