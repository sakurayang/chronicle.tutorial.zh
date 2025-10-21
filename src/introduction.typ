#import "/src/book.typ": book-page
#import "mods.typ":tips, info, warn, error, success
#show: book-page.with(title: "YourChronicle 中文教程")

= 简介<intro>

== 前言<front>

这篇教程是我在一边学习使用
#link("https://typst.app/")[Typst]
一边玩
#link("https://store.steampowered.com/app/1546320/Your_Chronicle/")[Your Chronicle]
的产物，在很大程度上参考了这篇文档=>
#link("https://docs.qq.com/doc/DRW51ckZ5dVZLQkZS")[Your Chronicle 中文百科攻略]。

重新写一遍并不是因为腾讯文档不好用，也不是因为原来的攻略有问题，
只是因为我自己想找一个能学习使用 Typst 的东西，所以就想到了写这个教程。

在开始动笔写这篇教程的时候刚到圣都，ed5都还没打，守护者5也没开，希望写完的时候能有所进展。
#strike[魔王大人一生推♥]

== 食用方式<how>

如果你正在使用的是网页版，那么在页面的左边应该就是目录，
如果你正在使用的是pdf版，那么大多数pdf阅读器都应该支持内置的pdf目录，同样也一般在左边。

同时你会在阅读的时候看见如下几种的提示框:

#tips[这种蓝色框的一般是一种一些比较重要的小技巧]
#info[这种一般是一些对某个阶段来说并不是很要紧的小贴士]
#warn[这种框的存在是为了提醒你某些事情]
#error[这种框是为了让你别去干某些事]
#success[这种框一般用来告诉你某些事成功了]


