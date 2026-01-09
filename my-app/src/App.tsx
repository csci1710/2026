import CS1710_Logo from "./assets/images/CS1710_logo2.svg";
import LFS_FROG from "./assets/images/lfs_frog_toad.jpg";
import "./App.css";
import Navbar from "./components/Navbar";
import HeroDivider from "./components/divider-images/hero-divider/HeroDivider";
import DividerA from "./components/divider-images/symmetrical-dividers/DividerA";
import AssignmentTable from "./components/AssignmentTable";
import {
  homeworkAssignments,
  labAssignments,
  projectAssignments,
  lectures,
  FAQLink,
  PUB,
  calendarLink,
} from "./SITE_DATA";
import Staff from "./components/Staff";
import { useInView } from "react-intersection-observer";
import { useState, useEffect } from "react";
import LecturesTable from "./components/LecturesTable";
import Resources from "./components/Resources";
import FooterDivider from "./components/divider-images/hero-divider/FooterDivider";

// Helper function to join class names on ternary conditionals
export function classNames(...classes: string[]) {
  return classes.filter(Boolean).join(" ");
}

function App() {
  // the index of the section currently in view (used for navbar purposes)
  const [inViewSection, setInViewSection] = useState<undefined | number>(0);
  const [aboutRef, aboutInView] = useInView();
  const [assignmentsRef, assignmentsInView] = useInView();
  const [lecturesRef, lecturesInView] = useInView();
  const [resourcesRef, resourcesInView] = useInView();
  const [calendarRef, calendarInView] = useInView();
  const [staffRef, staffInView] = useInView();

  // Detects the part of the page currently in view to the user
  useEffect(() => {
    [
      aboutInView,
      assignmentsInView,
      lecturesInView,
      resourcesInView,
      calendarInView,
      staffInView,
    ]
      .reverse()
      .forEach((val, index) => {
        if (
          !aboutInView &&
          !assignmentsInView &&
          !lecturesInView &&
          !resourcesInView &&
          !calendarInView &&
          !staffInView
        ) {
          setInViewSection(undefined);
        }

        if (val) {
          // If new sections are added, increase the number that you subtract from
          setInViewSection(5 - index);
          // console.log(4 - index);
        }
      });
  }, [
    aboutInView,
    assignmentsInView,
    lecturesInView,
    resourcesInView,
    calendarInView,
    staffInView,
  ]);

  return (
    <div className="">
      <header className="fixed top-0 z-50 w-full">
        <Navbar inView={inViewSection} />
      </header>
      <main className="mt-[14rem]">
        <body className="">
          <section
            id="intro"
            className="flex flex-col h-[30rem] items-center justify-center text-neutral-50"
          >
            <img
              src={CS1710_Logo}
              alt="CS1710 Logo"
              className="max-auto h-[12rem]"
            />
            <a href="https://forge-fm.github.io/book/" target="_blank">
              <img
                src={LFS_FROG}
                alt="Cute lil froggy"
                className="max-auto h-[20rem]"
              />
            </a>
          </section>

          <br />
          <br />
          <br />
          <br />
          <div
            className="w-full h-24"
            style={{ backgroundColor: "#606b54" }}
          ></div>

          <section
            id="about"
            ref={aboutRef}
            className="text-center flex flex-col items-center justify-center pt-20"
            style={{ color: "#966f51" }}
          >
            <h2 className="text-6xl font-title font-bold">About</h2>

            <div className="p-4" />
            <h4 className="font-bold pb-6 text-2xl">“What do you want?” </h4>
            <div className=" w-5/6 lg:w-3/4 text-lg">
              <p>
                This question is perilous, yet indispensable in life. And it
                remains vital in designing, understanding, and building systems.
                How will you check that you’ve achieved your goal? What is the
                cost, and which assumptions are you making along the way? Do you
                really want what you think you do, and will your code (or other
                artifact) actually work?
              </p>
              <div className="p-3" />
              <p>
                These questions matter, whether you’re crafting a new data
                structure, finishing up a programming assignment, designing a
                processor, or arguing over the rules of Monopoly with your
                family. In this course, you’ll use concrete software tools
                (e.g., model checkers and SAT solvers) to bring the power of
                automated reasoning to bear on these and other quandaries in,
                and outside of, computer science.
              </p>
              <div className="p-3" />
              <p className="flex flex-col items-center justify-center font-semibold">
                Logic for Systems is built on three broad learning categories:
                <ul className="list-disc pt-2 font-normal w-fit text-md flex flex-col text-left items-center justify-center">
                  <li className="w-3/4">
                    Modeling systems and making good abstraction choices;
                  </li>
                  <li className="w-3/4">
                    Reasoning about systems automatically using logic; and
                  </li>
                  <li className="w-3/4">
                    The foundational algorithms behind the tools used both in
                    this class and in industry.
                  </li>
                </ul>
              </p>
              <div className="p-3" />
              <p>
                The course culminates in a student-proposed, staff-mentored
                project that applies to a real-world system. Past projects have
                involved everything from distributed hash-tables to baseball
                games!
              </p>
              <div className="p-3" />
              <p>
                Prerequisite:{" "}
                <i>
                  <b>Any intro sequence!</b>
                </i>{" "}
                (CSCI 0160, CSCI 0180, CSCI 0190, or CSCI0200).
              </p>
              <div className="p-3" />
              <p className="italic bold" style={{ color: "#523e2f" }}>
                See the "Resources" section for the course syllabus!
              </p>
              <div className="p-3" />
              <p className="">
                If you're unsure about whether this is the right course for you,
                check out our{" "}
                <a
                  className="text-primary-500 underline font-bold"
                  href={FAQLink}
                  target="_blank"
                  style={{ color: "#2c7d39" }}
                >
                  FAQ
                </a>
                !
              </p>
              <div className="p-3" />
            </div>
          </section>

          <div className="p-6" />

          <br />
          <br />
          <div
            className="w-full h-20"
            style={{ backgroundColor: "#606b54" }}
          ></div>

          <section
            id="assignments"
            ref={assignmentsRef}
            className="text-center flex flex-col items-center justify-center pt-16"
            style={{ color: "#966f51" }}
          >
            <h2 className="text-6xl font-titl font-bold">Assignments</h2>
            <div className="p-4" />
            {/* <p className="italic text-neutral-500">
              (Unreleased assignments shown for more info during shopping
              period)
            </p> */}
            <div className="p-4" />
            <div className="grid grid-cols-1 md:grid-cols-2 gap-16">
              <AssignmentTable
                tablename="Homeworks"
                assignments={homeworkAssignments}
              />
              <AssignmentTable
                tablename="Labs (In-Person)"
                assignments={labAssignments}
              />
              <AssignmentTable
                tablename="Projects"
                assignments={projectAssignments}
              />
            </div>
          </section>

          <div className="p-6" />
          <br />
          <br />
          <div
            className="w-full h-20"
            style={{ backgroundColor: "#606b54" }}
          ></div>

          <section
            id="lectures"
            ref={lecturesRef}
            className="text-center flex flex-col items-center justify-center pt-16"
            style={{ color: "#966f51" }}
          >
            <h2 className="text-6xl font-title font-bold">Lectures</h2>
            <div className="p-4" />

            <LecturesTable lectures={lectures} />
          </section>

          <div className="p-6" />
          <br />
          <br />
          <div
            className="w-full h-20"
            style={{ backgroundColor: "#606b54" }}
          ></div>

          <section
            id="resources"
            ref={resourcesRef}
            className="text-center flex flex-col items-center justify-center pt-16"
            style={{ color: "#966f51" }}
          >
            <h2 className="text-6xl font-title font-bold">Resources</h2>
            <div className="p-4" />
            <Resources />
          </section>

          <div className="p-6" />
          <br />
          <br />
          <div
            className="w-full h-20"
            style={{ backgroundColor: "#606b54" }}
          ></div>

          <section
            id="calendar"
            ref={calendarRef}
            className="text-center flex flex-col items-center justify-center pt-16"
            style={{ color: "#966f51" }}
          >
            <h2 className="text-6xl font-title font-bold">Calendar</h2>
            <div className="p-4" />
            <a
              href={calendarLink}
              target="_blank"
              className="font-bold underline text-2xl"
            >
              Calendar Link (Add to your GCal)
            </a>
            <div className="p-4" />
            <iframe
              title="1710 Calendar"
              src="https://calendar.google.com/calendar/embed?src=c_d1eb86c31e85866f910be23c2f43a1e1b5ad0fab8fd473d9d3ca46873d3f4a11%40group.calendar.google.com&ctz=America%2FDetroit"
              // style="border: 0"
              width="800"
              height="600"
              // frameborder="0"
              scrolling="no"
            />
            <p className="text-neutral-500 italic pt-2">
              *You must be signed in to your Brown Google Account to see this
              calendar
            </p>
            <div className="p-4" />
          </section>

          <br />
          <br />
          <div
            className="w-full h-20"
            style={{ backgroundColor: "#606b54" }}
          ></div>

          <section
            id="staff"
            ref={staffRef}
            className="text-center flex flex-col items-center justify-center pt-16"
            style={{ color: "#966f51" }}
          >
            <h2 className="text-6xl font-title font-bold">Staff</h2>
            <div className="p-4" />
            <Staff />
          </section>
        </body>
        <p className="text-center p-16">
          © Spring 2026 cs1710 TA Staff |{" "}
          <a className="underline" target="_blank" href="http://cs.brown.edu/">
            Computer Science Department
          </a>{" "}
          |{" "}
          <a className="underline" target="_blank" href="http://brown.edu/">
            Brown University
          </a>
        </p>
        <FooterDivider />
      </main>
    </div>
  );
}

export default App;
