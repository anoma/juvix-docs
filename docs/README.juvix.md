---
nobuttons: true
title: Home
description: Juvix is a high-level programming language for writing privacy-preserving decentralised applications.
hide:
  - navigation
  - toc
social:
  cards: false
---

```juvix hide
module README;
  import Stdlib.Prelude open;
```


# **Juvix** a language for *intent-centric* and *declarative decentralized* applications

<div class="grid cards" markdown>

<div style="text-align:center" markdown>

<div style="text-align:center">
  <img src="assets/images/tara-smiling.svg" width="220" />
</div>

[Install Juvix on your machine](./howto/installing.md#shell-script){ .md-button .md-button--primary}

[:fontawesome-regular-circle-dot:{ .heart }  Try Juvix now on Codespaces](https://codespaces.new/anoma/applications-workshop?quickstart=1){ .md-button  }

</div>

<div markdown>

Juvix is an open-source functional language with static typing and
strict semantics. It is the programming language for the
[Anoma][anoma]'s blockchain. The primary purpose of this language is
to encode [Anoma's intents][anoma], enabling private and transparent
execution through the [Abstract Resource
Machine](https://art.anoma.net/list.html#paper-10498993) on the Anoma
blockchain.

Juvix, initially designed for Anoma, provides features typical of any
high-level programming language with many more on the horizon. It can
compile programs into native executable, WASM, Cairo bytecode and
arithmetic circuits facilitating zero-knowledge proofs.

Stay tuned for Juvix updates and follow us on [:material-twitter: Twitter][twitter]!

</div>

</div>

<div style="text-align:center" markdown>

## ... a brief overview of what Juvix is about

</div>


<div class="grid cards" markdown>

-   :fontawesome-solid-computer:{ .lg .middle } __How-to guides__

    ---

    Learn how to [install Juvix](./howto/installing.md) on macOS or Linux, as well as compile and
   document your Juvix projects.

    [:octicons-arrow-right-24: Quick start](./howto/quick-start.md)

    [:octicons-arrow-right-24: How-to guides](./howto/README.md)

-   :material-clock-fast:{ .lg .middle } __Tutorials__

    ---

    Master the essentials of Juvix through a series of
    tailored examples, tutorials and technical explanations.

    [:octicons-arrow-right-24: Functional programming with Juvix](./tutorials/learn.html)

    [:octicons-arrow-right-24: Tutorials](./tutorials/README.md)

-  :fontawesome-solid-video:{ .lg .middle } __Talks and Workshops__

    ---

    A collection of talks and workshop videos showcasing Juvix. Gain valuable
    insights and inspiration from our presentations at various conferences.

    [:octicons-arrow-right-24: Juvix videos](./talks.md)

-   :fontawesome-solid-lines-leaning:{ .lg .middle } __Reference__

    ---

    Explore the language reference, milestone examples, and tooling
    documentation!

    [:octicons-arrow-right-24: Reference](./reference/README.md)

    [:octicons-arrow-right-24: Standard library](https://anoma.github.io/juvix-stdlib/index.html)

    [:octicons-arrow-right-24: Packages and projects](./juvix-packages.md)

-   :material-account-group:{ .lg .middle } __Blog__

    ---

    Check out our blog to discover new features in the upcoming release, along
    with helpful examples and more.

    [:octicons-arrow-right-24: Blog](./blog/index.md)

-   :material-scale-balance:{ .lg .middle } __Open Source, GPL3.0__

    ---

    Juvix is licensed under GPL3 and available on [GitHub].

    [:octicons-arrow-right-24: License](https://github.com/anoma/juvix/blob/main/LICENSE.md)

</div>


[anoma]: https://anoma.net
[changelog]: https://docs.juvix.org/changelog.html
[geb]: https://github.com/anoma/geb
[GitHub]: https://github.com/anoma/juvix
[homebrew]: https://brew.sh
[juvix-book]: https://docs.juvix.org
[juvix-formula]: https://github.com/anoma/homebrew-juvix
[juvix-mode]: https://github.com/anoma/juvix-mode
[latest-release]: https://github.com/anoma/juvix/releases/latest
[nightly-builds]: https://github.com/anoma/juvix-nightly-builds
[repo-codespace]: https://github.com/codespaces/new?hide_repo_select=true&ref=main&repo=102404734&machine=standardLinux32gb&location=WestEurope
[repo]: https://github.com/anoma/juvix
[stdlib-codespace]: https://github.com/codespaces/new?hide_repo_select=true&ref=main&repo=102404734&machine=standardLinux32gb&location=WestEurope
[stdlib]: https://github.com/anoma/juvix-stdlib
[RM]: https://github.com/anoma/RM
[twitter]: https://twitter.com/juvixlang
[anomaTwitter]: https://twitter.com/anoma
[vampir]: https://github.com/anoma/vamp-ir
[vscode-plugin]: https://github.com/anoma/vscode-juvix
[website]: https://juvix.org
