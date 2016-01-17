gitbook2edx [![NPM version](https://badge.fury.io/js/gitbook2edx.svg)](http://badge.fury.io/js/gitbook2edx)
================================

> Convert a Gitbook into an Edx course. It generates a file  ready to be imported in Edx Studio.

## Install globally with [npm](npmjs.org):

```bash
npm i -g gitbook2edx
```

General help
------------

    Usage:
    gitbook2edx gen DIR [ -c CONFIG ]
    gitbook2edx json DIR [ -c CONFIG ]
    gitbook2edx info DIR [ -c CONFIG ]
    gitbook2edx -h | --help

Options:
    -h, --help              Just this help
    -c, --config CONFIG     Filename of the YAML configuration of the course

Arguments:
    DIR                     Root directory of the Gitbook to be converted

Commands:
    gen                     Generate the `course.tar.gz` file for the gitbook in DIR.


Detailed help
-------------

**Warning**: This command assumes a Gitbook 1.5.0 (or lower) format for
your book. I dont plan to follow strictly Gitbook releses, especially
concerning exercise authoring.

This command generates an archive with all the XML/HTML files needed to
bootstrap an Edx course based on a Gitbook. The following mappings are
used

-   Gitbook section -\> Edx Chapter
-   Gitbook subsection -\> Edx Sequential (plus one Edx Vertical for the
    content)

At the moment, only HTML is included in `course.xml`. In the future we
plan to convert also Gitbook exercises.

A part from `course.xml`, the archive will contain an `about` folder
with the required `overview.html` and `short_description.html`. Static
data, such as the course image and the js/css assets will be included in
the `static` subfolder.

### Prerequisites

To generate the course archive (`course.tar.gz`), the following
information is needed:

-   the root directory (`DIR`) of the Gitbook to be imported
-   the YAML configuration file (`CONFIG`) for the course. This one
    specifies the metadata information of the course such as start and
    end times, course description, teacher's bios. By default, this
    command looks for a `config.yaml` file in `DIR`. You can specify
    another value through the command line.
-   Optional: one `js` and one `css` file to be included as static
    assets in each vertical.

### Example

To generate `course.tar.gz` for a Gitbook in `test/javascript-master`
(assuming the configuration is `test/javascript-master/config.yaml`):

    gitbook2edx gen test/javascript-master

### Configuration file

Here you can find the configuration file `config.yaml` that shows the
mandatory information needed in the `config.yaml` file:

``` yaml
---
course:
    name: 'Computer Science'
    number: '80169'

    # The following two get concatenated to obtain the url_name
    year: '2014'
    season: 'spring'
organization:
    name: 'EXAMPLE-ORGNAME'
```

while all the available configuration options for the course are shown
here:

``` yaml
---
course:
    name: 'Computer Science'
    number: '80169'

    # The following two get concatenated to obtain the url_name
    year: '2014'
    season: 'spring'

    # Important dates (use JS's native Date parsing)
    start: 'March 1, 2015 8:00'
    end: 'June 3, 2015'

    enrollment_start: 'Feb 1, 2015'
    enrollment_end: 'Feb 1, 2015'

    # This is always relative to the 'DIR/_assets' directory
    image: 'course-image.jpg'

organization:
    name: 'EXAMPLE-ORGNAME'

assets:
    # The following are always relative to the 'DIR/_assets' directory
    # They are included in each vertical.
    js: 'client.js'
    css: 'client.css'

info:
    about: |
        You can use **markdown** here

    prerequisites: |
        You can use **markdown** here

    course-staff:

      - name: 'John Doe'
        image: 'http://www.dropbox.com/u/3989328983232y/image.jpg'
        bio: 'xlkxz xz lxzlk'

    faq:
      - question: 'Silly question?'
        answer: 'yes'

short-description:
    150 characters of course description.  
```

How to write exercises for the book.
------------------------------------

A programming exercise is defined directly in markdown by writing 4 simple parts between two `----` headers:

-   Exercise Message/Goals (in markdown/text)
-   Initial code to show to the user, providing a starting point
-   Solution code, being a correct solution to the exercise
-   Validation code that tests the correctness of the user's input

e.g:

    ----

    This is an octave exercise

    ``` octave
    a = 2034547;
    b = 1.567;
    c = 6758.768;
    d = 45084;
    x =
    ```

    ``` octave
    var a = 2034547;
    var b = 1.567;
    var c = 6758.768;
    var d = 45084;

    var x = ((a + b) / c) * d;
    ```

    ``` octave
    assert(x == (((a + b) / c) * d));
    ```

    ----

#### Quizzes

For quizzes the parts change a bit:

-   Exercise Message/Goals (in markdown/text)
-   All options allowed in the quiz (on separate lines)
-   All options associated with the solution
-   Feedback when the user fails to answer

e.g:

    ---

    What is the value of variable `x`

    ``` quiz
    3
    1
    2
    ```

    ``` quiz
    1
    ```

    ``` quiz
    `x` is the result of 3%2!
    ```
    ---

Author
------

-   Vittorio Zaccaria

License
-------

Copyright (c) 2016 Vittorio Zaccaria   Released under the  license

------------------------------------------------------------------------

_This file was generated by [verb-cli](https://github.com/assemble/verb-cli) on January 17, 2016._
