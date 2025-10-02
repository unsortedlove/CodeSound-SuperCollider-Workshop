/////////////////////////////////////////////////////
// SuperCollider Workshop – Beginner Guide
/////////////////////////////////////////////////////
// Luis Sanz | Aug 2025 | www.luissanz.ch
/////////////////////////////////////////////////////


////////// 1. SuperCollider Interface Overview

/*
When you first open SuperCollider, you will see:

- Workspace (left):
  This is where you type and evaluate code. Code written here
  is saved when you save your file.

- Post Window (lower right):
  SuperCollider communicates results, feedback, or error messages here.
  You can clear it by right-clicking → "Clear"
  (shortcut is in the menu — learn it, you’ll use it all the time).

- Help Documentation (upper right):
  Contains information about classes, methods, and examples.

--- Preferences ---
Menu: SuperCollider → Preferences
Here you can:
- Change text editor appearance
- Customize keyboard shortcuts
- Adjust editor behaviors
*/


////////// 2. Evaluating Code and Understanding Messages

/*
SuperCollider uses an object-oriented, message-passing style:
Objects receive messages (a.k.a. methods) to perform actions.

Syntax:
receiver.message
*/

// Example: cubing a number
3.cubed;  // 3^3 = 27

// To evaluate: place cursor on the line → press Shift + Return
// The result will appear in the Post Window.


// Example: error message
3.cudeb;
// -> Post window: "Message 'cudeb' not understood."
// (Because the method name is misspelled.)

// Example: syntax error (comma instead of period)
3,cubed;
// -> Post window will show a syntax error.


////////// 3. Variables

// Local variables (exist only inside the brackets they are declared in)
(
var number;       // declare
number = 3.cubed; // number = 27
number;           // evaluate variable
)

// Important: Local variables must be declared and used in the SAME block.


// Global variables (persist across evaluations)
// Prefix with tilde (~)
~number = 3.cubed;   // create global variable
~number;             // evaluate -> 27

// NOTE: Single letters a–z are reserved as global variables by SuperCollider.


////////// 4. Working with Multiple Statements

// All local variable statements must be evaluated together in the same block:

(
var snd;
snd = 3;
snd = snd.cubed;
snd = snd + 100;
snd = snd / 2;
snd;  // final result = 63.5
)


// If you skip the overwriting, values are computed but not stored:
(
var snd;
snd = 3;
snd.cubed;   // calculated but not stored
snd + 100;   // calculated but not stored
snd / 2;     // calculated but not stored
snd;         // still = 3
)


////////// 5. Comments

// Single-line comment looks like this

/*
Multi-line comments
can span
several lines
*/


////////// 6. Help Documentation

/*
- Put cursor on a method/word → Help → "Look up Documentation for Cursor"
  (shortcut: Cmd + D)

- Search across all help files: Shift + Cmd + D

Example: place cursor on "cubed" and press Cmd + D
→ opens help showing it works for Numbers and Collections.

- You can also search within a help document using the search bar,
  and navigate like a web browser.
*/


////////// Tips

/*
- Clear the Post Window often (keeps output readable).
- Use comments a lot (to remember what your code does).
- Practice with local vs. global variables to understand scope.
- Always check Help documentation to explore methods and classes.
*/
