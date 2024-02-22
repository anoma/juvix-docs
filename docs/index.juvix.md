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
module index;
  import Simulator open;
  import Simulator.Resource open using {mkResource as mkResource'};
  import Apps.TwoPartyExchange.Asset open;

  import Data.Map as Map;
  open Map using {Map};

  import Stdlib.Prelude open;
```


# **Juvix** a language for *intent-centric* and *declarative decentralized* applications

<div class="grid cards" markdown>

<div style="text-align:center" markdown>

<div style="text-align:center">
  <img src="assets/images/tara-smiling.svg" width="220" />
</div>

[Install Juvix on your machine](./howto/installing.md#shell-script){ .md-button .md-button--primary}

[:fontawesome-regular-circle-dot:{ .heart }  Try Juvix now on Codespaces](https://github.com/codespaces/new?hide_repo_select=true&ref=main&repo=102404734&machine=standardLinux32gb&location=WestEurope){ .md-button  }

</div>

<div markdown>

Juvix is an open-source functional language with static typing and strict
semantics. It is the programming language for the [Anoma][anoma]'s blockchain. The
primary purpose of this language is to encode [Anoma's intents][anoma], enabling
private and transparent execution through [RM][RM] on the Anoma
blockchain.

Juvix, initially designed for Anoma, provides features typical of any high-level
programming language with many more on the horizon. It can compile programs into
native executable, WASM, and arithmetic circuits using [VampIR][vampir] or
[Geb][geb], facilitating zero-knowledge proofs.

Stay tuned for Juvix updates! Follow us on [:material-twitter: Twitter][twitter]
and join our [:fontawesome-brands-discord: Discord][Discord] community.

<!-- To follow the development of Anoma, follow [:material-twitter: Anoma
Twitter][anomaTwitter] and join [:fontawesome-brands-discord: Anoma
Discord][anomaDiscord]. -->

</div>

</div>

<div style="text-align:center" markdown>

## ... a brief of what Juvix is about

</div>


<div class="grid cards" markdown>

<div markdown>

## :material-content-duplicate: Intents in Juvix for Anoma's dApps

What is an [intent](https://anoma.net/blog/intents-arent-real)? An intent, in
essence, is a high-level description, a message sent by programs to indicate
changes of a desired state.

Take for instance, Alice's intent. Her intent is to trade either two units of
resource `B` or one unit of resource `A` for a unit of `Dolphin`. Bob, on the other
hand, is willing to exchange one unit of resource `A` for 1 `Dolphin`. How can we
write these intents in Juvix? The conditions for Alice's intent is presented in
Juvix on the right, a **logic function** that validates the transaction.

See [here](https://anoma.github.io/abstract-resource-machine-simulator/Apps.TwoPartyExchange-src.html#1184) the full Juvix code for this example.

<div class="grid cards" style="text-align:center" markdown>

=== "Two-party exchange"

    ```mermaid
    flowchart LR
        A((Alice)) -- "Intent 1:\ntrade 1 A or 2 B for 1 Dolphin" ---> B[RM]
        X((Bob)) -- "Intent 2:\ntrade 1 Dolphin for 1 A" ---> B
        B --> P[Pool]
        S((Solver)) <----> P
        P -- "Intent solving" --> Z("Finalized\nTransaction")
        Z --> O[(Anoma)]
    ```

</div>

</div>

<div markdown>

## :octicons-mark-github-16: [`anoma/abstract-resource-machine-simulator`](https://github.com/anoma/abstract-resource-machine-simulator)

=== "Alice Intent"

    ```juvix
    module AliceIntent;
      import Stdlib.Trait.Eq open;

      logicFunction : ResourceKind -> PartialTx -> Bool
        | kind tx :=
          let
            createdRs : List Resource := createdResources tx;
            createdHashes : List LogicHash :=
              map Resource.logicHash createdRs;
          in isCreated kind
            || (quantityOfDenom Dolphin.denomination createdRs == ofNat 1
              && quantityOfDenom A.denomination createdRs == ofNat 1)
            || quantityOfDenom Dolphin.denomination createdRs == ofNat 1
            && quantityOfDenom B.denomination createdRs == ofNat 2;

      --- This will be computed from the logic function
      logicHash : LogicHash := 1;

      staticData : ByteString := 3 :: nil;

      denomination : Denomination := 1 :: staticData;

      mkResource (n : Int) : Resource :=
        mkResource'
          (logicHash := logicHash;
          staticData := staticData;
          dynamicData := nil;
          quantity := n);
    end;
    ```

=== "Partial transactions"

    ```juvix
    module Alice;
    -- Alice is willing to exchange either 2 B or 1 A for 1 Dolphin.
    partialTransaction : PartialTx :=
      mkPartialTx
        (consumedPair := A.mkResource 1, B.mkResource 2;
        createdPair := AliceIntent.mkResource 1, dummyResource);
    end;

    module Bob;
      partialTransaction : PartialTx :=
        mkPartialTx
          (consumedPair := Dolphin.mkResource 1, dummyResource;
          createdPair := A.mkResource 1, dummyResource);
    end;

    module Solver;
      partialTransaction : PartialTx :=
        mkPartialTx
          (consumedPair := AliceIntent.mkResource 1, dummyResource;
          createdPair := Dolphin.mkResource 1, B.mkResource 2);
    end;
    ```

=== "Logics"

    ```juvix
    logicFunctions : Map LogicHash LogicFunction :=
      mkLogicFunctionMap
        ((AliceIntent.logicHash, AliceIntent.logicFunction) :: nil);
    ```

    ```juvix
    import Test.JuvixUnit open;

    {-
    twoPartyExchange : Test :=
        let
            txs : List PartialTx :=
            Alice.partialTransaction
                :: Bob.partialTransaction
                :: Solver.partialTransaction
                :: nil;
        in testCase
            "two party exchange"
            (assertTrue
            "expected two-party exchange transactions to validate"
            (checkTransaction logicFunctions txs));
    -}
    ```

<!-- !!!info "Note"

    See also the Sudoku intent example: [here](https://anoma.github.io/abstract-resource-machine-simulator/Apps.Sudoku.html#). -->

</div>
</div>


=== "Abstract Resource Machine Simulator"

    How to write intents in Juvix to validate transactions in Anoma is further
    elaborated in both the [RM
    Simulator](https://github.com/anoma/abstract-resource-machine-simulator) repository and the [Juvix
    Workshop](https://github.com/anoma/juvix-workshop).

=== "Transaction lifecycle"

    ```mermaid
    sequenceDiagram
        UserWallet ->>RM API: use intent to create ptxs
        RM API  -->>UserWallet: returns ptxs
        UserWallet  ->>Solvers: send a ptxs
        Solvers   ->>Solvers: match/broadcast ptxs
        Solvers  -->>RM API: create helper ptxs
        RM API  -->>Solvers: gives helper ptxs
        Solvers   ->>RM API: create a tx
        RM API  -->>Solvers: returns a finalized tx
        Solvers  ->>Finaliser : submit finalized transaction
            Finaliser ->> RM API: verify the finalized transaction
        RM API ->> Finaliser: return the result (valid/invalid)
        Finaliser -->> Blockchain: commit a (balanced) tx
        Blockchain ->> Blockchain: run consensus Typhon alg.
        Blockchain ->> RM API: verify the transaction
        RM API -->> Blockchain: return the result (valid/invalid)
    ```



<div class="grid cards" markdown>

<div markdown>

## :material-graph-outline: Arithmetic Circuits / Zero-knowledge Proofs

An arithmetic circuit is an algebraic representation, essentially expressing a
system of polynomial equations in a universal, canonical form that model the
computation of a program. Arithmetic circuits are used in zero-knowledge proofs
and Juvix can compile programs into these representations via our in-house
compiler [VampIR][vampir].

```mermaid
flowchart LR
    A[Juvix file]  -- Juvix --> B[VampIR circuit]
    B -- VampIR --> C[PLONK or Halo2 circuit]
```

```shell
juvix compile -t vampir Hash.juvix
```

The VampIR file can then be compiled to a PLONK circuit:

```shell
vamp-ir plonk setup -m 14 -o input.pp
vamp-ir plonk compile -u input.pp -s Hash.pir -o c.plonk
```

A zero-knowledge proof that `hash 1367` is equal to `3` can then be generated
from the circuit:

```shell
vamp-ir plonk prove -u input.pp \
                    -c c.plonk \
                    -o proof.plonk -i Hash.json
```

This proof can then be verified:

```shell
vamp-ir plonk verify -u input.pp -c c.plonk -p proof.plonk
```

</div>

<div markdown>

## :octicons-mark-github-16: [`anoma/juvix-workshop`](https://github.com/anoma/juvix-workshop/blob/main/arithmetic-circuits/README.md)

=== "Hash.juvix"

    ```juvix
    module Hash;

      import Stdlib.Prelude open;

      {-# unroll: 30 #-}
      terminating
      power' (acc a b : Nat) : Nat :=
        let
          acc' : Nat := if (mod b 2 == 0) acc (acc * a);
        in if (b == 0) acc (power' acc' (a * a) (div b 2));

      power : Nat → Nat := power' 1 2;

      hash' : Nat -> Nat -> Nat
        | (suc n@(suc (suc m))) x :=
          if
            (x < power n)
            (hash' n x)
            (mod (div (x * x) (power m)) (power 6))
        | _ x := x * x;

      hash : Nat -> Nat := hash' 16;

      main : Nat -> Nat := hash;
    end;
    ```

=== "Hash.json"

    ```json
    {
    "in": "1367",
    "out": "3"
    }
    ```


!!!info "Note"

    For further details, refer to [Compiling Juvix programs to arithmetic circuits
    via Vamp-IR](./blog/posts/vampir-circuits.md).

</div>

</div>

<div style="text-align:center" markdown>

## :material-firework: Juvix is growing fast!

</div>

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

    [:octicons-arrow-right-24: Learn Juvix in 5 minutes](./tutorials/learn.juvix.md)

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

    [:octicons-arrow-right-24: Reference](./reference/language/functions.juvix.md)

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
[anomaDiscord]: https://discord.gg/jwzaMZ2Sct
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
