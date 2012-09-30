Nikiru - the web framework that gets out of your way
====================================================

### What is Nikiru? ###

Nikiru is a web application framework that is inspired by Web2Py (Python) and Rails (Ruby). But instead of trying to give you a complete framework that forces you to learn the framework "language", Nikiru simply aids you in your CFML knowledge and gives you "Abstraction Layers". Nikiru focuses on rapid development and follows a Model View Controller design.

Any Nikiru application is comprised of Models (files that contain a description of the data representation), Views (files that contain a description of the data presentation), Controllers (files that contain a description of the business logic and workflow), Modules (collections of reusable classes and functions), and Static Files (images, scripts, stylesheets, etc.).

Controllers consist of functions that are associated to a URL and are called when the associated URL is visited. Models are executed before the function is called, independently on the visited URL (for each app). Views are called when the function returns data other than a string, and renders the data in the proper format.

### Nikiru Framework Helpers ###

As mentioned, Nikiru tries to go out of your way, thus you can write your controllers, views and controllers in pure CFML with the help of some framework functions like:

#### Database Helper ####
As an example you can simply select from the database with "db_select()".

#### Form Helper ####
Nikiru additionaly creates forms automatically from your database columns (added within the model) with a simple form_do().

#### Translation built in ####
Nikiru makes use of Resource Bundles and integrates them easily with a function called T().

#### Bootstrap enabled ####
By default, Nikiru comes with Bootstrap from Twitter.

### Why CFML / ColdFusion? ###

Compared to PHP, Java, C++, even Ruby and Python – CFML allows you to write the same program with much much fewer lines of code. Why would you want spend your precious time writing more code when you can do it for less? As a matter of fact, you can write your application in CFML so efficiently, that the same application written by you alone would probably need a team with oher languages.

But since you are already looking at this I think you know your way around CFML. In case you want to read more about the cons of CFML you can read one of my [blog posts](http://thenitai.com/2012/02/04/why-coldfusion-cfml-has-its-place-and-is-worth-to-learn-it/)

### Support ###



Please use the main repo's [issue tracker](https://github.com/bobsilverberg/CFSelenium/issues) to report bugs and request enhancements.