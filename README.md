------------
SCOPE
------------
My goal was to create a data product which is suitable for comparing prices and attributes between refrigerators. I intended to create a concept of analysis as a pilot that can be extended further later on. 
The focus of my work was all the refrigerators available in the product selection of Mediamarkt and Edigital on a given day. I scraped items on 23 December 2019. All in all I scraped 436 refrigerators from edigital.hu and 350 refrigerators from medimarkt.hu

I had two main data products as an output of my work. First, I created a data table, which is searchable by technical attributes and makes it possible to compare websites based on item prices. The final data table (dt_refrigerator_workfile) contains all the items that were listed on the two examined websites. I identified the same products, merged them, and gave them a common unique item ID.
The second data product of mine is a Web Application that was created in order both to make the comparison easier and to make the output visually more tangible.

------------
USED TOOLS
------------
I used rvest package of R for scraping data. For data cleaning I combined R and OpenRefinee open source tool of Google. I developed the webapp in Shiny.

------------
FOLDERS:
------------
- raw: contains R codes for web scraping and the scraped raw data tables.

- clean: contains R code for data cleaning, semi cleaned data files in tsv format, and it also includes JSON code generated on OpenRefine.

- work: contains R code of Shiny application and the final version of cleand workfile in different fileformats (txt, json and tsv). Shiny app can be found on this link: https://gulyati.shinyapps.io/Refrigerators/. The folder also includes VARIABLES.txt as the description of variables.
