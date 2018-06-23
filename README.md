# scrape

### **When you need those jobs fast...._scrape_**

Command line script that builds CSV results of job searches. Check
out the `jobs` folder some recent **_scrape_**_s_. **_scrape_** is built with:

- [Ruby](https://www.ruby-lang.org)
- [Mechanize](https://github.com/sparklemotion/mechanize)
- [OptionParser](https://docs.ruby-lang.org/en/2.5.0/OptionParser.html)
- [Rubocop](https://github.com/rubocop-hq/rubocop)
- [Paint](https://github.com/janlelis/paint)
- [RubyCritic](https://github.com/whitesmith/rubycritic)
- [CSV class](https://ruby-doc.org/stdlib-2.5.0/libdoc/csv/rdoc/CSV.html)
- [XPath](https://en.wikipedia.org/wiki/XPath)
- [CSV](https://en.wikipedia.org/wiki/Comma-separated_values)
- [YAML](http://yaml.org/)
- [Markdown](https://daringfireball.net/projects/markdown/syntax)
- [GitHub Pages](https://pages.github.com/)
- [Flag Counter](https://flagcounter.com)

Hey Wow :) looks like there are still jobs for [Cobol](
https://en.wikipedia.org/wiki/COBOL)

### Seek 

Large Australian employment marketplace
[https://www.seek.com.au/](https://www.seek.com.au/)  

```
$ ruby seek.rb -h
Usage: seek.rb [options]
    -k, --keyword keyword            Keywords to search
    -l, --location location          Suburb, city or region
    -d, --daterange daterange        Listed time in days
                                          999 (default) or
                                          1, 3, 7, 14, 31 or
                                          any positive number
    -w, --worktype worktype          Work type
                                        all (default)
                                        full or 242 (full time)
                                        part or 243 (part time)
                                        contract or 244 (contract/temp)
                                        casual or 245 (casual/vacation)
    -h, --help                       Displays help
        --version                    Show version

```
Or to enter interactive mode
```
$ ruby seek.rb 
Enter keywords: git python
Enter suburb, city or region: sydney
Listed time in days: 30
Work type: full
3 jobs found
```

Code overview of ``seek.rb`` can be seen on the [RubyCritic page](
http://thebeast.me/scrape/rubycritic/overview.html)


<a href="https://info.flagcounter.com/0gCz">
    <img src="https://s05.flagcounter.com/count2/0gCz/bg_FFFFFF/txt_000000/border_CCCCCC/columns_2/maxflags_250/viewers_0/labels_1/pageviews_0/flags_0/percent_0/" alt="Flag Counter">
</a>
