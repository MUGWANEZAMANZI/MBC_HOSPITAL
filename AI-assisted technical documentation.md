# AI-assisted technical documentation

## 1. Objective and scenario

### Objective

Use AI to generate, structure, and refine a complete set of technical documents for a fictional web application. This lab focuses on using AI for technical writing, structuring information, and ensuring accuracy.

### Scenario

- The project: You are a developer on the "TaskFlow" team, a task management web app. The app's core functionality is complete, but the documentation is messy — scattered across developer notes, Slack threads, and old wiki pages.

- The task: Your team lead has asked you to create clear, concise documentation so that new developers can onboard quickly, QA testers can understand expected behaviours, and end users can get started without asking for help.

**Key considerations:**

| Area | Detail |
| --- | --- |
| Consistency | All documents must follow a consistent style (headings, tone, examples) |
| Clarity | Use simple, plain English — avoid jargon where possible |
| Accuracy | You must fact-check the AI's suggestions — the AI will generate plausible content, but you must ensure it matches the provided sample project files and specs |

---

## 2. Final deliverables

Submit a single, well-organized documentation file (PDF or Markdown) containing:

- A "Getting Started" guide — for end users, explaining how to use the app's basic features

- An API reference — for other developers, detailing the exposed endpoints

- A troubleshooting section — for common errors or frequently asked questions

- Your prompt history — a log of the prompts you used to generate and refine this content

- A short reflection (200 words or fewer) answering:

  - What was the hardest part of this task? (e.g., fact-checking, getting the tone right)

  - How did iterative prompting (refining your prompts) change the quality of the documentation?

---

## 3. Step-by-step instructions

### Phase 1: Understand the task (15 mins)

- Read the scenario and the "TaskFlow" project files and specs

- Review the deliverables and constraints (style, clarity, accuracy)

- Check the evaluation rubric in Section 4 to understand the success criteria

### Phase 2: Deconstruct the problem (30 mins)

Break the large task into three smaller, logical parts:

- Generate the "Getting Started" guide

- Generate the "API Reference"

- Generate the "Troubleshooting" section

Draft initial "first pass" prompts for each part.

### Phase 3: Iterative prompting and chaining (60 mins)

- First pass — run your initial prompts. The AI's output will be a generic template.

- Review — compare the AI's template to the "TaskFlow" project files. Note the gaps and inaccuracies.

- Refine — feed the AI specific context from the project files. This is the most important step.

|  | Example |
| --- | --- |
| Bad prompt | "Write an API reference." |
| Good prompt | "Act as a technical writer. Here is a JavaScript code snippet for my API's '/login' endpoint: [paste code snippet]. Write an API reference for this endpoint, including the path, method, expected JSON body, and a 200/401 response example." |

- Chain — use the AI to standardize style across sections

Example: "Take the 'Getting Started' guide and the 'Troubleshooting' section I've written and rewrite them to have the same professional, clear, and simple tone. Ensure all main headings are H2 and sub-headings are H3."

- Assemble — combine all three fact-checked and refined sections into your final document

### Phase 4: Submit and reflect (15 mins)

- Assemble your final document, prompt history, and reflection

- Proofread for clarity and consistency before submitting

---

## 4. Evaluation rubric

| Criteria | Points | Description |
| --- | --- | --- |
| Completeness and accuracy | 5 | All 3 sections are present and technically accurate to the project data |
| Clarity for non-technical users | 5 | "Getting Started" guide is free of jargon and easy to follow |
| Formatting and readability | 5 | Document has a logical order, is easy to scan, and uses consistent formatting |
| Use of iteration and chaining | 3 | Prompt history shows progressive refinement and fact-checking |
| Reflection on process | 2 | Reflection shows thoughtful evidence of the iteration process |
| Total | 20 |  |
