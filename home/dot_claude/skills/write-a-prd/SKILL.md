---
name: write-prd
description: Create a PRD through user interview, codebase exploration, and module design, then submit it as a markdown document. Use when user wants to write a PRD, create a product requirements document, or plan a new feature.
---

This skill will be invoked when the user wants to create a PRD. You may skip steps if you don't consider them necessary.

1. Ask the user for a long, detailed description of the problem they want to solve and any potential ideas for solutions.

2. Explore the repo to verify their assertions and understand the current state of the codebase.

3. Interview the user relentlessly about every aspect of this plan until you reach a shared understanding. Walk down each branch of the decision tree, resolving dependencies between decisions one-by-one.

4. Sketch out the major modules, and seervices you will need to build or modify to complete the implementation. Actively look for opportunities to extract deep modules that can be tested in isolation.

A deep module (as opposed to a shallow modules) is one which encapsulates a lot of functionality in a simple, testable interface which rarely changes.

Check with the user that these modules match their expectations.
Check with the user which modules the want tests written for.

5. Once you have a complete understanding of the problem and solution, use the template below to write the PRD. The PRD should be expored into a markdown file, in the `docs/prds` directory of the current project.

<prd-template>
## Problem statement

The problem that the user is facing, from the user's perspective.

## Solution

The solution to the problem, from the user's perspective.

## User stories

Bullet points of user stories, from all consumers of the problem.

## Use cases

</prd-template>
