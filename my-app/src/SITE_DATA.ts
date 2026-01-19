// This file contains all of the information that should be easily accessible by components of the site

// Importantly, all external links are stored here so that
// between course updates, this is the only file that needs to
// be checked for updates

// SECURITY NOTE:
/* 
This entire file is sent to the client,
Any links that appear here (even if commented
out or set to "go live" later) are technically
accessible to people who care to look for them.

If you happen to be one of the savvy students that
has discovered this "treasure trove" of unreleased
material, congratulations! Neat find ;) However, please
be aware that even if an unreleased link exists here, it's probably
not live for a reason, and you probably shouldn't use anything
that we didn't intend for you to use yet. 

This is a tradeoff we make by choosing to simplify hosting of
the website with no significant backend logic. Now, go take
a security class!
*/

// DON'T TOUCH THIS
// Able to reference content in the public folder (PUB + "/...")
export const PUB = process.env.PUBLIC_URL;

// ------ EDIT STUFF BELOW THIS LINE ------

export const announcementInfo = {
  // Appears at the top of the screen attached to navbar,
  // if an announcement exists
  message: "We'd love to hear what you think, submit anonymous feedback!",
  buttonText: "Give Feedback",
  buttonLink:
    "https://docs.google.com/forms/d/1KreaxonPm0yHkpdu0Pg9bagNk3ygip3K7fcQNIsajhQ/viewform?edit_requested=true",
  // Set & Forget tools:
  autoReleaseDate: "Feb 21, 2026 09:45:00 EST", // Automatically shows announcement on this date/time EST
  autoDismissDate: "May 14, 2026 09:00:00 EST", // Automatically removes announcement on this date/time EST
  // Announcement will be shown on page load and manually dismissable between the above two dates
};

export const lectures: Lecture[] = [
  // {
  //   name: "What is LfS?",
  //   date: "Jan 22",
  //   notesLink:
  //     "https://csci1710.github.io/book/chapters/manifesto/manifesto.html",
  //   recordingLink: "",
  //   otherLinks: [
  //     {
  //       name: "Amazon AWS Zelkova (Whitepaper)",
  //       link: "https://aws.amazon.com/blogs/security/protect-sensitive-data-in-the-cloud-with-automated-reasoning-zelkova/",
  //     },
  //     {
  //       name: "Some Industrial Applications",
  //       link: "https://github.com/ligurio/practical-fm",
  //     },
  //   ],
  // },
  // {
  //   name: "Properties and Testing",
  //   date: "Jan 24",
  //   notesLink: "https://csci1710.github.io/book/chapters/properties/pbt.html",
  //   recordingLink: "",
  //   liveCodeLink: "",
  // },
  // {
  //   name: "Intro to Modeling in Froglet (Part 1, Basics)",
  //   date: "Jan 27",
  //   notesLink: "https://csci1710.github.io/book/chapters/ttt/ttt.html",
  //   recordingLink: "",
  //   liveCodeLink:
  //     "https://github.com/csci1710/2025/blob/main/my-app/public/livecode/2025/jan27_ttt.frg",
  // },
  // {
  //   name: "Intro to Modeling (Part 2, Transitions); Showcase",
  //   date: "Jan 29",
  //   notesLink: "https://csci1710.github.io/book/chapters/bst/bst.html",
  //   recordingLink: "",
  //   liveCodeLink:
  //     "https://github.com/csci1710/2025/blob/main/my-app/public/livecode/2025/jan29_ttt.frg",
  // },
  // {
  //   //name: "Design-Space Exploration and Constraint Solving",
  //   name: "Intro to Modeling (Part 3, Traces)",
  //   date: "Jan 31",
  //   notesLink: "https://csci1710.github.io/book/chapters/adder/rca.html",
  //   recordingLink: "",
  //   liveCodeLink:
  //     "https://github.com/csci1710/2025/blob/main/my-app/public/livecode/2025/jan31_ttt.frg",
  // },
  // {
  //   //name: "Discrete Event Systems",
  //   name: "Intro to Modeling (Part 4, FAQ)",
  //   date: "Feb 03",
  //   notesLink: "https://csci1710.github.io/book/chapters/qna/static.html",
  //   recordingLink: "",
  //   liveCodeLink:
  //     "https://github.com/csci1710/2025/blob/main/my-app/public/livecode/2025/feb03_ttt.frg",
  // },
  // {
  //   name: "Discrete Events and Traces (Part 1, Doing Nothing Productively)",
  //   date: "Feb 05",
  //   notesLink: "https://csci1710.github.io/book/chapters/ttt/ttt_games.html",
  //   recordingLink: "",
  //   liveCodeLink: "",
  // },
  // {
  //   name: "Discrete Events and Traces (Part 2, Preservation)",
  //   date: "Feb 07",
  //   notesLink:
  //     "https://csci1710.github.io/book/chapters/inductive/bsearch.html",
  //   recordingLink: "",
  //   liveCodeLink: "",
  // },
  // {
  //   name: "Inductive Verification: Binary Search (Part 1)",
  //   date: "Feb 10",
  //   notesLink:
  //     "https://csci1710.github.io/book/chapters/inductive/bsearch.html",
  //   recordingLink: "",
  //   liveCodeLink:
  //     "https://github.com/csci1710/2025/blob/main/my-app/public/livecode/2025/feb10_bsearch.frg",
  // },
  // {
  //   name: "Inductive Verification: Binary Search (Part 2)",
  //   date: "Feb 12",
  //   notesLink: "",
  //   recordingLink: "",
  //   liveCodeLink:
  //     "https://github.com/csci1710/2025/blob/main/my-app/public/livecode/2025/feb12_bsearch.frg",
  //   otherLinks: [
  //     {
  //       name: "TTT Games",
  //       link: "https://github.com/csci1710/2025/blob/main/my-app/public/livecode/2025/feb12_ttt.frg",
  //     },
  //   ],
  // },
  // {
  //   name: "Inductive Verification: Binary Search (Part 3)",
  //   date: "Feb 14",
  //   notesLink:
  //     "https://csci1710.github.io/book/chapters/validation/validating_events.html",
  //   recordingLink: "",
  //   liveCodeLink: "",
  // },
  // {
  //   name: "Modeling syntax, semantics, and sets: Relational Forge",
  //   date: "Feb 19",
  //   notesLink:
  //     "https://csci1710.github.io/book/chapters/relations/modeling-booleans-1.html",
  //   recordingLink: "",
  //   liveCodeLink:
  //     "https://github.com/csci1710/2025/blob/main/my-app/public/livecode/2025/feb19_boolean.frg",
  // },
  // {
  //   name: "Modeling syntax, semantics, and sets: Relational Forge",
  //   date: "Feb 21",
  //   notesLink:
  //     "https://csci1710.github.io/book/chapters/relations/modeling-booleans-1.html",
  //   recordingLink: "",
  //   liveCodeLink:
  //     "https://github.com/csci1710/2025/blob/main/my-app/public/livecode/2025/feb21_boolean.frg",
  // },
  // {
  //   name: "Join and Reachability",
  //   date: "Feb 24",
  //   notesLink:
  //     "https://csci1710.github.io/book/chapters/relations/reachability.html",
  //   recordingLink: "",
  //   liveCodeLink:
  //     "https://github.com/csci1710/2025/blob/main/my-app/public/livecode/2025/feb24_join.frg",
  // },
  // {
  //   name: "Modeling Mutex (Part 1)",
  //   date: "Feb 26",
  //   notesLink:
  //     "https://csci1710.github.io/book/chapters/relations/sets-induction-mutex.html",
  //   recordingLink: "",
  //   liveCodeLink:
  //     "https://github.com/csci1710/2025/blob/main/my-app/public/livecode/2025/feb26_mutex.frg",
  // },
  // {
  //   name: "Modeling Mutex (Part 2)",
  //   date: "Feb 28",
  //   notesLink:
  //     "https://csci1710.github.io/book/chapters/relations/sets-induction-mutex.html",
  //   recordingLink: "",
  //   liveCodeLink:
  //     "https://github.com/csci1710/2025/blob/main/my-app/public/livecode/2025/feb28_mutex.frg",
  // },
  // {
  //   name: "Liveness and Lassos",
  //   date: "Mar 03",
  //   notesLink:
  //     "https://csci1710.github.io/book/chapters/temporal/liveness_and_lassos.html",
  //   recordingLink: "",
  //   liveCodeLink:
  //     "https://github.com/csci1710/2025/blob/main/my-app/public/livecode/2025/mar03_mutex.frg",
  // },
  // {
  //   name: "Temporal Forge",
  //   date: "Mar 05",
  //   notesLink:
  //     "https://csci1710.github.io/book/chapters/temporal/temporal_operators.html",
  //   recordingLink: "",
  //   liveCodeLink:
  //     "https://github.com/csci1710/2025/blob/main/my-app/public/livecode/2025/mar05_mutex.frg",
  //   otherLinks: [
  //     {
  //       name: "Integer counter model",
  //       link: "https://github.com/csci1710/2025/blob/main/my-app/public/livecode/2025/mar05_counter.frg",
  //     },
  //   ],
  // },
  // {
  //   name: "Modeling Mutex (Part 3, Temporally)",
  //   date: "Mar 07",
  //   notesLink:
  //     "https://csci1710.github.io/book/chapters/temporal/temporal_operators_2.html",
  //   recordingLink: "",
  //   liveCodeLink:
  //     "https://github.com/csci1710/2025/blob/main/my-app/public/livecode/2025/mar07_mutex.frg",
  // },
  // {
  //   name: "Obligations and the Past",
  //   date: "Mar 10",
  //   notesLink:
  //     "https://csci1710.github.io/book/chapters/temporal/obligations_past.html",
  //   recordingLink: "",
  //   liveCodeLink: "",
  //   // otherLinks: [
  //   //   {
  //   //     name: "Traffic lights model",
  //   //     link: "https://csci1710.github.io/book/chapters/temporal/traffic.frg",
  //   //   },
  //   // ],
  // },
  // {
  //   name: "Modeling Temporal Logic, Data Structures",
  //   date: "Mar 12",
  //   notesLink: "",
  //   recordingLink: "",
  //   liveCodeLink: "",
  // },
  // {
  //   name: "Deadlocks, Peterson's Lock (Part 1)",
  //   date: "Mar 14",
  //   notesLink:
  //     "https://csci1710.github.io/book/chapters/temporal/fixing_lock_temporal.html",
  //   recordingLink: "",
  //   liveCodeLink:
  //     "https://github.com/csci1710/2025/blob/main/my-app/public/livecode/2025/mar14_mutex.frg",
  //   otherLinks: [
  //     {
  //       name: "In-class Starter",
  //       link: "https://github.com/csci1710/2025/blob/main/my-app/public/livecode/2025/mar14_starter.frg",
  //     },
  //   ],
  // },
  // {
  //   name: "Peterson's Lock (Part 2)",
  //   date: "Mar 17",
  //   notesLink:
  //     "https://csci1710.github.io/book/chapters/temporal/fixing_lock_temporal.html",
  //   recordingLink: "",
  //   liveCodeLink:
  //     "https://github.com/csci1710/2025/blob/main/my-app/public/livecode/2025/mar17_mutex.frg",
  // },
  // {
  //   name: "Finishing Mutex, How Forge Works",
  //   date: "Mar 19",
  //   notesLink:
  //     "https://csci1710.github.io/book/chapters/solvers/bounds_booleans_how_forge_works.html",
  //   recordingLink: "",
  //   liveCodeLink:
  //     "https://github.com/csci1710/2025/blob/main/my-app/public/livecode/2025/mar19_bounds.frg",
  //   otherLinks: [
  //     {
  //       name: "Fixing Peterson",
  //       link: "https://github.com/csci1710/2025/blob/main/my-app/public/livecode/2025/mar17_mutex.frg",
  //     },
  //   ],
  // },
  // {
  //   name: "Q&A, Debugging Tips",
  //   date: "Mar 21",
  //   notesLink: "",
  //   recordingLink: "",
  //   liveCodeLink:
  //     "https://github.com/csci1710/2025/blob/main/my-app/public/livecode/2025/assert_ltl.frg",
  // },
  // {
  //   name: "Solving SAT (Part 1)",
  //   date: "Mar 31",
  //   notesLink: "https://csci1710.github.io/book/chapters/solvers/dpll.html",
  //   recordingLink: "",
  //   liveCodeLink: "",
  // },
  // {
  //   name: "Solving SAT (Part 2)",
  //   date: "Apr 02",
  //   notesLink: "https://csci1710.github.io/book/chapters/solvers/dpll.html",
  //   recordingLink: "",
  //   liveCodeLink: "",
  // },
  // {
  //   name: "Resolution (Part 1)",
  //   date: "Apr 04",
  //   notesLink:
  //     "https://csci1710.github.io/book/chapters/solvers/resolution.html",
  //   recordingLink: "",
  //   liveCodeLink: "",
  // },
  // {
  //   name: "Resolution (Part 2)",
  //   date: "Apr 07",
  //   notesLink:
  //     "https://csci1710.github.io/book/chapters/solvers/resolution.html",
  //   recordingLink: "",
  //   liveCodeLink: "",
  // },
  // {
  //   name: "Resolution (Part 3)",
  //   date: "Apr 09",
  //   notesLink:
  //     "https://csci1710.github.io/book/chapters/solvers/resolution.html",
  //   recordingLink: "",
  //   liveCodeLink: "",
  // },
  // {
  //   name: "(Optional) Future of 1710",
  //   date: "Apr 11",
  //   notesLink: "",
  //   recordingLink: "",
  //   liveCodeLink: "",
  // },
  // {
  //   name: "SMT (Whirlwind Tour)",
  //   date: "Apr 14",
  //   notesLink: "",
  //   recordingLink: "",
  //   liveCodeLink: "",
  // },
  // {
  //   name: "SMT (Applications)",
  //   date: "Apr 16",
  //   notesLink: "",
  //   recordingLink: "",
  //   liveCodeLink: "",
  // },
  // {
  //   name: "Guest: Milda Zizyte",
  //   date: "Apr 18",
  //   notesLink: "",
  //   recordingLink: "",
  //   liveCodeLink: "",
  // },
  // {
  //   name: "SMT (CEGIS, Closing)",
  //   date: "Apr 21",
  //   notesLink: "",
  //   recordingLink: "",
  //   liveCodeLink: "",
  // },
  // {
  //   name: "Guest: Anjali Pal",
  //   date: "Apr 23",
  //   notesLink: "",
  //   recordingLink: "",
  //   liveCodeLink: "",
  // },
  // {
  //   name: "Guest: Margarida Ferreira",
  //   date: "Apr 25",
  //   notesLink: "",
  //   recordingLink: "",
  //   liveCodeLink: "",
  // },
  // {
  //   name: "Guest: Anirudh Narsipur",
  //   date: "Apr 28",
  //   notesLink: "",
  //   recordingLink: "",
  //   liveCodeLink: "",
  // },
  // {
  //   name: "Guest: Andrew Wagner",
  //   date: "Apr 30",
  //   notesLink: "",
  //   recordingLink: "",
  //   liveCodeLink: "",
  // },
  // {
  //   name: "Guest: Carolyn Zech",
  //   date: "May 02",
  //   notesLink: "",
  //   recordingLink: "",
  //   liveCodeLink: "",
  // },
];

// For assignments, exclude HREF field to automatically disable the assignment
export const homeworkAssignments: Assignment[] = [
  {
    name: "PBT",
    dateRange: "Jan 23 → Jan 29, 2026",
    href: "https://hackmd.io/@csci1710/rkWPh6tN-l",
    autoReleaseDate: "Jan 23, 2026 15:00:00 EST",
  },
  {
    name: "Modeling Intro",
    dateRange: "Jan 30 → Feb 5, 2026",
    href: "https://hackmd.io/@csci1710/B1NEG7jKa",
    autoReleaseDate: "Jan 30, 2026 15:00:00 EST",
  },
  {
    name: "Physical Keys",
    dateRange: "Feb 6 → Feb 12, 2026",
    href: "https://hackmd.io/@csci1710/ByLnzQstT",
    autoReleaseDate: "Feb 6, 2026 15:00:00 EST",
  },
  {
    name: "Memory Management",
    dateRange: "Feb 27 → Mar 5, 2026",
    href: "https://hackmd.io/@csci1710/S1xVNmiK6",
    autoReleaseDate: "Feb 27, 2026 15:00:00 EST",
  },
  {
    name: "Temporal Modeling",
    dateRange: "Mar 7 → Mar 12, 2026",
    href: "https://hackmd.io/@csci1710/HJk8E7jFa",
    autoReleaseDate: "Mar 7, 2026 15:00:00 EST",
  },
  {
    name: "SAT",
    dateRange: "Mar 13 → Mar 19, 2026",
    href: "https://hackmd.io/@csci1710/SJvrLGYH-g",
    autoReleaseDate: "Mar 13, 2026 15:00:00 EDT",
  },
  {
    name: "SMT 1",
    dateRange: "Apr 3 → Apr 9, 2026",
    href: "https://hackmd.io/@csci1710/rkzzBmoYa",
    autoReleaseDate: "Apr 3, 2026 15:00:00 EDT",
  },
  {
    name: "SMT 2",
    dateRange: "Apr 10 → Apr 16, 2026",
    href: "https://hackmd.io/@csci1710/HyCHj6CEZx",
    autoReleaseDate: "Apr 10, 2026 15:00:00 EDT",
  },
  // {
  //   // Rickroll ;)
  //   name: "Hardest Assignment Ever...",
  //   dateRange: "Oct 25 → Oct 26, 2009",
  //   href: "https://www.youtube.com/watch?v=xvFZjo5PgG0",
  //   autoReleaseDate: "Jan 25, 2026 21:28:59 EST",
  // },
  // ...
];

export const labAssignments: Assignment[] = [
  {
    name: "(Optional) Async Python",
    dateRange: "Jan 21, 2026",
    href: "https://hackmd.io/@csci1710/By-lPmstT",
    autoReleaseDate: "Jan 21, 2026 09:45:00 EST",
  },
  // {
  //   name: "Tic Tac Toe",
  //   dateRange: "Jan 28 → Jan 29, 2026",
  //   href: "https://hackmd.io/@csci1710/HkOLBXstT",
  //   autoReleaseDate: "Jan 28, 2026 15:00:00 EST",
  // },
  {
    name: "N Queens",
    dateRange: "Feb 4 → Feb 5, 2026",
    href: "https://hackmd.io/@csci1710/BkYfImjKp",
    autoReleaseDate: "Feb 4, 2026 15:00:00 EST",
  },
  {
    name: "Ring Election",
    dateRange: "Feb 11 → Feb 12, 2026",
    href: "https://hackmd.io/@csci1710/ryC5S7jt6",
    autoReleaseDate: "Feb 13, 2026 15:00:00 EST",
  },
  {
    name: "Curiosity co-lab",
    dateRange: "Feb 18 → Feb 19, 2026",
  },
  {
    name: "Reference Counting",
    dateRange: "Feb 25 → Feb 26, 2026",
    href: "https://hackmd.io/@csci1710/S1LXKW2t6",
    autoReleaseDate: "Feb 25, 2026 15:00:00 EST",
  },
  {
    name: "Dining Blacksmiths",
    dateRange: "Mar 4 → Mar 5, 2026",
    href: "https://hackmd.io/@csci1710/HkbhU7sta",
    autoReleaseDate: "Mar 4, 2026 15:00:00 EST",
  },
  {
    name: "Sociotech Discussion",
    dateRange: "Mar 11 → Mar 12, 2026",
    href: "",
    autoReleaseDate: "Mar 11, 2026 15:00:00 EST",
  },
  {
    name: "SAT co-lab",
    dateRange: "Apr 18 → Apr 19, 2026",
  },
  {
    name: "Proposal co-lab",
    dateRange: "Apr 1 → Apr 2, 2026",
  },
];

export const projectAssignments: Assignment[] = [
  {
    name: "Curiosity Modeling",
    dateRange: "Feb 13 → Feb 26, 2026",
    href: "https://hackmd.io/@csci1710/rJm6XmjKT",
    autoReleaseDate: "Feb 13, 2026 15:00:00 EST",
  },
  {
    name: "Final Project (Proposal)",
    dateRange: "Mar 20 → Apr 2, 2026",
    href: "https://hackmd.io/@csci1710/ByCXUZ2KT",
    autoReleaseDate: "Mar 20, 2026 15:00:00 EST",
  },
  {
    name: "Final Project",
    dateRange: "Apr 18 → May 7, 2026",
    href: "https://hackmd.io/@csci1710/ByCXUZ2KT",
    autoReleaseDate: "Apr 18, 2026 15:00:00 EST",
  },
];

// export const forgeDocsLink: string = "";
// export const EdStemLink: string = "";

export const FAQLink: string =
  "https://docs.google.com/document/d/e/2PACX-1vQek5FgRtgmr7rdxOnq5qzTIaRoVcc0dN4dERg5qu4oJ4hTCAmWJkrBbNWUdm_zsMRtQOmzpG17fWQK/pub";

export const policies: Resource[] = [
  {
    name: "Syllabus",
    href: "https://docs.google.com/document/d/1tk0HNlvfhKPG8qVTdeZkbNdr1riRtZelWzsGt1NyZ7g/edit?usp=sharing",
  },
  {
    name: "Guide to Effective AI Use",
    href: "https://docs.google.com/document/d/1_uj3kxTXzTSVpDodqQpLLaCZKT5y9x-oznn3cnlx4SQ/edit?usp=sharing",
  },
  // {
  //   name: "Collaboration Policy",
  //   href: "",
  //   // "https://docs.google.com/document/d/e/2PACX-1vQ7b5GLg6Kie0l4zzuLLQ7oaC89V931dqbHQl7Rgr7sVT05bIu1WrGTcNaGpn9gg5y9Tc7GvLS32vf1/pub",
  // },
];

export const importantLinks: Resource[] = [
  {
    name: "EdStem",
    href: "https://edstem.org/us/join/V9WucK",
  },
  { name: "Hours", href: "https://hours.cs.brown.edu/login" },
  {
    name: "Collaboration Form",
    href: "https://forms.gle/dHaaedpVFh7k4D1x9",
  },
  {
    name: "Brown CS Health and Wellness",
    href: "https://cs.brown.edu/about/diversity/resources/",
  },
  {
    name: "Ever True Resources",
    href: "https://evertrue.brown.edu/resources/",
  },
];

export const guides: Resource[] = [
  {
    name: "Setup & Installation",
    href: "https://hackmd.io/@csci1710/r1rZAWeo6",
  },
  {
    name: "Forge Book",
    href: "https://forge-fm.github.io/book/",
  },
  {
    name: "Forge Tool Documentation",
    href: "https://forge-fm.github.io/forge-documentation/home.html",
  },
  // {
  //   name: "Toadus Ponens Guide",
  //   href: "",
  //   // "https://docs.google.com/document/d/1zdv6uF7jdC8CR-d73AojsH68jaLmNG3MwlcZ9R2lWpc/edit?usp=sharing",
  // },
  {
    // Goes live later in semester
    name: "Python Z3",
    href: "", // Greyed out for now
    // href: "https://docs.google.com/document/d/1ri_-SadZ-IWqrg3ZNY6tJRB_0OSDdwJRYNtdHkSehuc/preview",
  },
];

export const professor: staffMember = {
  name: "Tim Nelson",
  image: PUB + "/images/staff/tim.jpeg",
  alt_image: PUB + "/images/staff/tim_frog.jpeg",
  alt_objectPosition: "90% 50%",
  pronouns: "he/they",
  bio: 'I’m a first-generation college student who attended community college, a state college, the "college" of an industry job, and a STEM university. Now I teach at Brown. You might call this a collage of colleges, although not quite a universe of universities.',
  favorite_amphibian: "Neutral (as a professor, I can't play favorites!)",
  role: "Professor",
  // favorite_amphibian_image: "",
};

export const htas: staffMember[] = [
  {
    name: "Sarah Ridley",
    image: PUB + "/images/staff/sarah.JPG",
    objectPosition: "center 65%",
    // alt_image: PUB + "/images/staff/megan_frog.jpeg",
    pronouns: "she/her",
    bio: "Hi! I'm a senior from North Carolina studying computer science. This is my second year as an HTA for 1710, and I'm so excited for this spring! Outside of cs, I love sewing, baking, my cat, and doing jigsaw puzzles.",
    favorite_amphibian: "Team Frog",
    role: "HTA",
  },
];

export const utas: staffMember[] = [
  {
    name: "Ruth Ukubay",
    image: PUB + "/images/staff/ruth.jpeg",
    alt_objectPosition: "center 65%",
    pronouns: "she/her",
    bio: "Hi! I’m Ruth, a senior concentrating in Computer Science from Ethiopia:) I love pickleball and do a lot of restaurant hopping in my free time. I am so excited to be your TA this semester!",
    favorite_amphibian: "Team Toad",
    role: "UTA",
  },

  {
    name: "Dior Williams",
    image: PUB + "/images/staff/dior.jpg",
    objectPosition: "center 15%",
    // alt_image: PUB + "/images/staff/conrad_frog.jpeg",
    alt_objectPosition: "center 25%",
    pronouns: "she/her",
    bio: "Hi, I am a senior from Houston, Texas. I love playing video games, watching movies, and this is my first time TAing a CS class. I'm usually in the EEPS department, so feel free to ask me questions about that too. :)",
    favorite_amphibian: "Team Toad",
    role: "UTA",
  },
  {
    name: "Joshua Kou",
    image: PUB + "/images/staff/joshua.jpg",
    objectPosition: "center 35%",
    // alt_image: PUB + "/images/staff/kendra_frog.jpeg",
    pronouns: "he/him",
    bio: "Hi I'm Joshua, a sophomore studying math and cs from Austin, Texas. I enjoy learning number theory and playing board/card/social deduction games. I love talking about or being introduced to anything in those categories!",
    favorite_amphibian: "Team Frog",
    role: "UTA",
  },
  {
    name: "Snoop Frogg",
    image: PUB + "/images/staff/snoop.jpg",
    objectPosition: "center 40%",
    alt_image: PUB + "/images/staff/snoop_alt.jpg",
    pronouns: "he/they",
    bio: '"Rapper, producer, formal method and modeler."',
    favorite_amphibian: "Team Frog, duh",
    role: "UTA",
  },
];

export const gradtas: staffMember[] = [
  {
    name: "Siddhartha Prasad",
    image: PUB + "/images/staff/siddhartha.jpeg",
    alt_image: PUB + "/images/staff/siddhartha_frog.jpeg",
    bio: "“Frog pushed a coat down over the top of Toad. Frog pulled snowpants up over the bottom of Toad. He put a hat and scarf on Toad’s head. ‘Help!’ cried Toad. ‘My best friend is trying to kill me!’ ‘I’m only getting you ready for winter,’ said Frog. ”",
    pronouns: "he/him",
    favorite_amphibian: "Team Toad",
    role: "Grad TA",
  },
  {
    name: "Toadus Ponens",
    image: PUB + "/images/staff/algo_ribbit.jpeg",
    //alt_image: PUB + "/images/staff/algo_ribbit_alt.jpeg",
    bio: "Croak",
    pronouns: "he/they",
    favorite_amphibian: "Team Toad, obviously",
    role: "Grad TA",
  },
];

export const calendarLink =
  "https://calendar.google.com/calendar/u/0?cid=Y19kMWViODZjMzFlODU4NjZmOTEwYmUyM2MyZjQzYTFlMWI1YWQwZmFiOGZkNDczZDlkM2NhNDY4NzNkM2Y0YTExQGdyb3VwLmNhbGVuZGFyLmdvb2dsZS5jb20";
// Type definitions

export type Resource = {
  name: string;
  href: string;
};

export type Lecture = {
  name: string;
  date: string; // Jan 28
  description?: string; // Short 1-2 sentence lecture description, optional
  notesLink?: string;
  recordingLink?: string;
  liveCodeLink?: string;
  // Arbitrary links with arbitrary names:
  otherLinks?: { name: string; link: string }[]; // NOTE: Nothing preventing name conflict between notes/recording/livecode name
};

// export type LectureWeek = {
//   name: string; // week X
//   dailyLectures: Lecture[];
// };

export type Assignment = {
  name: string;
  dateRange: string;
  href?: string; // If left blank, assignment appears as disabled
  autoReleaseDate?: string; // Will treat href as "blank" until this date/time (EST)
};

export type staffMember = {
  name: string;
  image: string;
  objectPosition?: string; // Fix image alignment if necessary (on mobile wrong part of image gets cut off)
  alt_image?: string; // On image hover, the image changes to alt image
  alt_objectPosition?: string; // Same as objectPosition but for alt image
  pronouns: string;
  bio: string;
  favorite_amphibian: string;
  role: string; // prof/hta/uta/sta...
  // favorite_amphibian_image: string;
};
