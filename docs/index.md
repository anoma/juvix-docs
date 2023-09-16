---
nobuttons: true
title: Home
description: Juvix is a high-level programming language for writing privacy-preserving decentralised applications.
hide:
  - navigation
  - toc
---

# Welcome to the Juvix documentation!

<div class="grid cards" markdown>

Juvix is an open-source, ever-evolving functional language for creating
privacy-focused decentralized apps. It allows developers to write high-level
programs that compile to WASM or, via [VampIR][vampir], to circuits for private
execution using [Taiga][taiga] on [Anoma][anoma] or Ethereum.
</div>


<div class="grid cards" markdown>

<div markdown>

## :material-content-duplicate: Intents in Juvix for Anoma

An intent is a high-level description of a transaction the user wants to
perform. It is a program that describes the conditions under which a transaction
is valid. For example, Alice wants to exchange 2 B or 1 A for 1 Dolphin.

Read more on Anoma's intents [here](https://anoma.net/blog/intents-arent-real).

<div style="text-align:center" markdown>

<div style="text-align:center">
  <img src="assets/images/tara-smiling.svg" width="250" />
</div>


[Try Juvix now on Codespaces](https://github.com/codespaces/new?hide_repo_select=true&ref=main&repo=102404734&machine=standardLinux32gb&location=WestEurope){ .md-button .md-button--primary }

</div>


</div>

<div style="padding: 1rem 0 0 0" markdown>


:octicons-mark-github-16: [`anoma/juvix-workshop`](https://github.com/anoma/taiga-simulator)

```juvix
...
-- Alice is willing to exchange either 2 B or 1 A for 1 Dolphin.
module Apps.TwoPartyExchange;
--- Definitions related to Alice's intent
module AliceIntent;
  logicFunction : LogicFunction
    | kind tx :=
        let
            {- check if the resource associated to
            this logic function is among the created (output) resources.
            Then check if alice's intent is satisfied. -}
            createdRs : List Resource := createdResources tx;
            createdHashes : List LogicHash :=
                map logicHash createdRs;
        in isCreated kind
      || quantityOfDenom Dolphin.denomination createdRs == 1
      && quantityOfDenom A.denomination createdRs == 1
      || quantityOfDenom Dolphin.denomination createdRs == 1
      && quantityOfDenom B.denomination createdRs == 2;
 ...
```

</div>

</div>


## :material-graph-outline: Juvix Compilation to Arithmetic Circuits

<div class="grid cards" markdown>

<div markdown>

A significant feature of Juvix includes compiling programs into arithmetic circuits for confidential execution, achieved via the in-house [VampIR][vampir] compiler. Arithmetic circuits model the computation of Juvix programs by representing polynomial computations. These circuits can be executed privately using [Taiga][taiga]. Essentially, arithmetic circuits are systematic polynomial equations expressed in a universal, canonical form.

See more [Compiling Juvix programs to arithmetic circuits via Vamp-IR](./blog/posts/vampir-circuits.md).

</div>

<div markdown>

```juvix
module FastExponentiation;

{-# unroll: 30 #-}
terminating
power' (acc a b : Nat) : Nat :=
  let acc' : Nat := if (mod b 2 == 0) acc (acc * a);
  in if (b == 0) acc (power' acc' (a * a) (div b 2));
power : Nat → Nat → Nat := power' 1;

end;
```

</div>

</div>


## :material-firework: Juvix is growing fast!

<div class="grid cards" markdown>

-   :fontawesome-solid-computer:{ .lg .middle } __How-to guides__

    ---

    Learn how to [install Juvix](./howto/installing.md) on macOS or Linux, as well as compile and
   document your Juvix projects.

    [:octicons-arrow-right-24: Quick start ](./howto/quick-start.md)

    [:octicons-arrow-right-24: How-to guides ](./howto/installing.md)

-   :material-clock-fast:{ .lg .middle } __Tutorials__

    ---

    Master the essentials of Juvix through a series of
    tailored examples, tutorials and technical explanations.

    [:octicons-arrow-right-24: Learn Juvix in 5 minutes](./tutorials/learn.md)

<!-- -  :fontawesome-solid-book-open:{ .lg .middle } __Explanations__

    ---

    A series dedicated to delivering more in-depth technical explanations of Juvix.

    [:octicons-arrow-right-24: Read the book](./explanations/README.md) -->

-  :fontawesome-solid-video:{ .lg .middle } __Talks and Workshops__

    ---

    A collection of talks and workshop videos showcasing Juvix. Gain valuable
    insights and inspiration from our presentations at various conferences.

    [:octicons-arrow-right-24: Juvix videos](./about/talks.md)

-   :fontawesome-solid-lines-leaning:{ .lg .middle } __Reference__

    ---

    Explore the Language reference, milestone examples, and tooling
    documentation!

    [:octicons-arrow-right-24: Reference](./reference/language/functions.md)

-   :material-account-group:{ .lg .middle } __Blog__

    ---

    Check out our blog to discover new features in the upcoming release, along
    with helpful examples and more. And, don't forget to join us on [Discord].

    [:octicons-arrow-right-24: Blog](./blog/index.md)

    [:octicons-arrow-right-24: Join us](./about/community.md)

-   :material-scale-balance:{ .lg .middle } __Open Source, GPL3.0__

    ---

    Juvix is licensed under GPL3 and available on [GitHub].

    [:octicons-arrow-right-24: License](./about/license.md)

</div>


[anoma]: https://anoma.net
[changelog]: https://docs.juvix.org/changelog.html
[Discord]: https://discord.gg/jwzaMZ2Sct
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
[taiga]: https://github.com/anoma/taiga
[twitter]: https://twitter.com/juvixlang
[vampir]: https://github.com/anoma/vamp-ir
[vscode-plugin]: https://github.com/anoma/vscode-juvix
[website]: https://juvix.org
