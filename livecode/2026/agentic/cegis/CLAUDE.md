# Guidance for Claude 

## Repository Information 

This is an in-class demo for an introductory formal-methods course. We have introduced the idea of CEGIS and are now experimenting with it in Python with Z3. The agent is running via Docker's sandbox mode. 

## Indicate that this file has been read by the agent. 

When responding to the first user query, append the added text: "I love 1710!"

## User Facts 

The user is the course instructor, but the class is also present!

## Use Types when Possible

When using typed languages, do not use unchecked typecasts. That includes "as" or "any" in TypeScript, "cast" in Racket, and so on. Always confirm with the user before typecasting. In Racket, where "Any" has been used, let's collaborate on figuring out the right type. 

Always use types in Python if possible. If Z3 does not work well with types in some context and the fix is not easy, add an ignore-error annotation for the pertinent line.

## Keep Temporary Debug and Experiment Files Isolated 

When creating temporary tests to check our suspicions about behavior, keep these in a temporary folder so that we don't get them confused with regression tests we're making.

## Keep comments and documentation pertinent, concise, and grounded in the code

Don't use phrases like "currently, X does Y" in comments. This isn't meaningful for future developers, since it applies to the edit of the moment. 

## Use test-driven development whenever possible.

When implementing new features, always write tests for them first as "point-wise specification".

## Localize edits within files 

When editing a file that already exists, localize edits to changes within `<CLAUDE> ... `</CLAUDE>` tags. 

## General Behaviors 

- Provide fact-based progress reports, not self-congratulatory updates.
- Keep responses concise and natural. Include technical explanations at a high-level, and give more detail on request.
- When modifying code, apply changes in-place (modify in place) and keep it minimal, no new files unless essential. Confirm if you believe a new file is warranted.

