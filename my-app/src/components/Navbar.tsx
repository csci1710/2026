import { PUB } from "../SITE_DATA";
import Announcement from "./Announcement";

function scrollToTop() {
  window.scrollTo({ top: 0, behavior: "smooth" });
}

function scrollIntoView(id: string) {
  let yOffset = -150;
  console.log("called!");
  if (window.matchMedia("(max-width: 768px)").matches) {
    // On smaller devices, move the section bar up a little further
    yOffset = -60;
    // console.log("small screen!");
  }

  // -100 for sm/md
  const element = document.querySelector(id);
  if (element != null) {
    const y = element.getBoundingClientRect().top + window.scrollY + yOffset;
    window.scrollTo({ top: y, behavior: "smooth" });
  }
}

export default function Navbar({ inView }: { inView: number | undefined }) {
  const sections = [
    { id: "#about", name: "About" },
    { id: "#assignments", name: "Assignments" },
    { id: "#lectures", name: "Lectures" },
    { id: "#resources", name: "Resources" },
    { id: "#calendar", name: "Calendar" },
    { id: "#staff", name: "Staff" },
  ];

  return (
    <>
      <nav className="bg-[#9fa980] text-neutral-50 flex items-center justify-left h-20">
        <div className="text-white text-sm sm:text-lg font-title w-full flex justify-around items-center">
          {sections.map((section, index) => (
            <button
              key={index}
              onClick={() => {
                scrollIntoView(section.id);
              }}
              className={
                "transition-all duration-200 " +
                (inView === index ? "underline text-lg sm:text-xl" : "")
              }
            >
              {section.name}
            </button>
          ))}
        </div>
      </nav>
      <Announcement />
    </>
  );
}  