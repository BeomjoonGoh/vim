<!---
Markdown cheatsheet

Maintainer:  Beomjoon Goh
Last Change: 08 Mar 2020 03:33:12 +0900
-->

# Headers

# H1
## H2
### H3
#### H4
##### H5
###### H6

# Emphasis

*italic*, _italic_

**bold**, __bold__

***bold italic***, ___bold italic___

`code`

~~removed~~

# Lists

* Unordered
* Item 1
  * Item 1a
- This too
+ Or this

1. Ordered
1. Can use other numbers.
   1. Sub list

# Todo Lists

- [ ] Do this
- [x] Done
- [ ] Any list syntax will do

# Links

[Inline-style](https://www.google.com)

[Inline-style with title](https://www.google.com "Google's Homepage")

[Inline-style link to a header](#links)

[Inline-style link to a file](../see/this)

[reference-style][Case-insensitive Text]

[reference-style with number][1]

[Text itself], without parentheses.

URLs and URLs in angle brackets <http://www.example.com>.

[case-insensitive text]: https://www.mozilla.org
[1]: http://slashdot.org
[Text itself]: http://www.reddit.com

# Images

Same as links but with \! in front: ![an image](./img/image.png)

Or use HTML with whatever attributes you need:
<img src="./img/image.png" height="30">

# Code blocks

```cpp
int main(void) {
  std::cout << "Hello, World!" << std::endl;
  return 0;
}
```

    4 spaces indent

```
# No syntax hightlight
echo "Hello, World!"
```

# Tables

| Table | Alphabet | Number  |
|-------|:--------:| -------:|
| row 1 | a        | 1       |
| row 2 | b        | 2       |

# Block quotes

> Block quotes
> > Nested quotes

# Inline HTML

<dl>
  <dt>Definition list</dt>
  <dd>Is something people use sometimes.</dd>
</dl>

# Others

## Horizontal Rules

Three or more of
******
------
______

## Escapes

\\ ,\` ,\* ,\_ ,\{\} ,\[\] ,\(\) ,\# ,\+ ,\- ,\.  ,\!
 
## Comments

<!-- HTML comments -->

<!--
Multi line
comments
-->

[//]: # "Comment abusing empty links"

[//]: # (parentheses works too)

[//]: # "
Multi line comment
As long as there's no blank line.
"
