import { Fragment } from "react";
import { classNames } from "../App";
import { Lecture, lectures } from "../SITE_DATA";

type LectureTableProps = {
  lectures: {
    name: string;
    date: string; // Jan 28
    description?: string; // Short 1-2 sentence lecture description, optional
    notesLink?: string;
    recordingLink?: string;
    liveCodeLink?: string;
    // Arbitrary links with arbitrary names:
    otherLinks?: { name: string; link: string }[]; // NOTE: Nothing preventing name conflict between notes/recording/livecode name
  }[];
};

export default function LecturesTable(props: LectureTableProps) {
  return (
    <div className="mt-8 flex flex-col">
      <div className="-my-2 -mx-4 overflow-x-auto sm:-mx-6 lg:-mx-8">
        <p>
          The listed lecture schedule is prospective and subject to change. All
          lecture capture videos can be found on our 2026 Canvas{" "}
          <a
            href="https://canvas.brown.edu/courses/1101694/external_tools/33943"
            target="_blank"
          >
            media library page
          </a>
          .
        </p>
        <p>
          Notes can be found on our{" "}
          <a href="https://forge-fm.github.io/book/2026" target="_blank">
            Forge book deployment
          </a>
          , even if the specific chapters are not yet linked below.
        </p>
        <div className="inline-block min-w-full py-2 align-middle md:px-6 lg:px-8">
          <div className="overflow-hidden shadow ring-1 ring-black ring-opacity-5 md:rounded-lg">
            <table className="min-w-full divide-y divide-gray-300">
              <thead className="bg-gray-50">
                <tr>
                  <th
                    scope="col"
                    className="py-3.5 pl-4 pr-3 text-center text-sm font-semibold text-gray-900 sm:pl-6"
                  >
                    Name
                  </th>
                  <th
                    scope="col"
                    className="py-3.5 pl-4 pr-3 text-center text-sm font-semibold text-gray-900 sm:pl-6"
                  >
                    Date
                  </th>
                  <th
                    scope="col"
                    className="py-3.5 pl-4 pr-3 text-center text-sm font-semibold text-gray-900 sm:pl-6"
                  >
                    Book/Notes
                  </th>
                  {/* <th
                    scope="col"
                    className="py-3.5 pl-4 pr-3 text-center text-sm font-semibold text-gray-900 sm:pl-6"
                  >
                    Recording
                  </th> */}
                  <th
                    scope="col"
                    className="py-3.5 pl-4 pr-3 text-center text-sm font-semibold text-gray-900 sm:pl-6"
                  >
                    Live Code
                  </th>
                  <th
                    scope="col"
                    className="py-3.5 pl-4 pr-3 text-center text-sm font-semibold text-gray-900 sm:pl-6"
                  >
                    Other Links
                  </th>
                </tr>
              </thead>
              <tbody className="divide-y divide-gray-200 bg-white">
                {props.lectures.map((lecture) => (
                  <tr key={lecture.name}>
                    <td className="py-4 pl-4 pr-3 text-sm font-medium text-black sm:pl-6">
                      {lecture.name}
                    </td>
                    <td className="whitespace-nowrap py-4 pl-4 pr-3 text-sm font-medium text-black sm:pl-6">
                      {lecture.date}
                    </td>
                    {lecture.notesLink ? (
                      <td>
                        <a
                          href={lecture.notesLink}
                          className="whitespace-nowrap py-4 pl-4 pr-3 text-sm font-bold underline sm:pl-6"
                        >
                          Notes
                        </a>
                      </td>
                    ) : (
                      <td className="whitespace-nowrap py-4 pl-4 pr-3 text-sm font-medium text-gray-400 sm:pl-6">
                        -
                      </td>
                    )}
                    {/* {lecture.recordingLink ? (
                      <td>
                        <a 
                          href={lecture.recordingLink}
                          className="whitespace-nowrap py-4 pl-4 pr-3 text-sm font-bold underline sm:pl-6"
                        >
                          Recording
                        </a>
                      </td>
                    ) : (
                      <td className="whitespace-nowrap py-4 pl-4 pr-3 text-sm font-medium text-gray-400 sm:pl-6">-</td>
                    )}   */}
                    {lecture.liveCodeLink ? (
                      <td>
                        <a
                          href={lecture.liveCodeLink}
                          className="whitespace-nowrap py-4 pl-4 pr-3 text-sm font-bold underline sm:pl-6"
                        >
                          Live Code
                        </a>
                      </td>
                    ) : (
                      <td className="whitespace-nowrap py-4 pl-4 pr-3 text-sm font-medium text-gray-400 sm:pl-6">
                        -
                      </td>
                    )}
                    {lecture.otherLinks ? (
                      <td>
                        {lecture.otherLinks.map((otherLink, index) => (
                          <span key={index}>
                            <a
                              href={otherLink.link}
                              className="whitespace-nowrap py-4 pl-4 pr-3 text-sm font-bold underline sm:pl-6"
                            >
                              {otherLink.name}
                            </a>
                            <br />
                          </span>
                        ))}
                      </td>
                    ) : (
                      <td className="whitespace-nowrap py-4 pl-4 pr-3 text-sm font-medium text-gray-400 sm:pl-6">
                        -
                      </td>
                    )}
                  </tr>
                ))}
              </tbody>
            </table>
          </div>
        </div>
      </div>
    </div>
  );
}

// export default function LecturesTable(props: LecturesTableProps) {
//   return (
//     <div className="flex flex-col items-stretch w-5/6 justify-center">
//       <div className="flex items-center justify-center">
//         <ol className="text-left w-5/6 relative border-l border-gray-200 dark:border-gray-700">
//           {props.weeks.map((week, idx) => (
//             <Fragment key={week.name}>
//               {/* <div
//               className={
//                 idx !== 0 ? "mt-6 pt-6 border-t-2 border-neutral-600" : ""
//               }
//             /> */}
//               <div className={"flex flex-col"}>
//                 <h4 className="font-title text-5xl mt-10 pl-4"> {week.name}</h4>
//                 <div className="p-2" />

//                 {week.dailyLectures.map((lecture) => (
//                   <div className="mt-2 text-xl">
//                     <LectureDay lecture={lecture} />
//                   </div>
//                 ))}
//               </div>
//             </Fragment>
//           ))}
//         </ol>
//       </div>
//     </div>
//   );
// }

const linkClassName =
  "inline-flex items-center px-4 py-2 text-sm font-bold text-primary-700 bg-white border border-gray-200 rounded-lg hover:bg-primary-500 hover:text-neutral-50 focus:z-10 focus:ring-4 focus:outline-none focus:ring-gray-200 focus:text-primary-400";

function LectureDay(props: { lecture: Lecture }) {
  return (
    <li className="mb-4 ml-4 items-stretch ">
      <div className="absolute w-3 h-3 bg-gray-200 rounded-full mt-1.5 -left-1.5 border border-white dark:border-gray-900 dark:bg-gray-700"></div>
      <time className="mb-1 text-sm font-normal leading-none text-gray-400 dark:text-gray-500">
        {props.lecture.date}
      </time>
      <h3 className="text-2xl font-title text-gray-900 dark:text-white">
        {props.lecture.name}
      </h3>
      <p className="mb-4 text-base font-normal text-gray-500 dark:text-gray-400 w-full ">
        {props.lecture.description}
      </p>
      <div className="grid grid-cols-2 lg:grid-cols-3 xl:grid-cols-4 gap-x-2 gap-y-1">
        {props.lecture.notesLink && (
          <a
            href={props.lecture.notesLink}
            target="_blank"
            className={linkClassName}
          >
            Notes
          </a>
        )}
        {props.lecture.recordingLink && (
          <a
            href={props.lecture.recordingLink}
            target="_blank"
            className={linkClassName}
          >
            Recording
          </a>
        )}
        {props.lecture.liveCodeLink && (
          <a
            href={props.lecture.liveCodeLink}
            target="_blank"
            className={linkClassName}
          >
            Livecode
          </a>
        )}
        {props.lecture.otherLinks?.map((otherLink) => (
          <a href={otherLink.link} target="_blank" className={linkClassName}>
            {otherLink.name}
          </a>
        ))}
      </div>
    </li>
  );
}

function LectureDayOld(props: { lecture: Lecture }) {
  return (
    <div className="flex text-center items-center justify-center space-x-2 text-neutral-900 px-4">
      <p className="font-bold">
        <span className="text-neutral-600 font-medium">
          {props.lecture.date}:{" "}
        </span>
        {props.lecture.name}
      </p>
      <div className="flex space-x-2">
        {props.lecture.notesLink && (
          <a
            href={props.lecture.notesLink}
            className="text-primary-500 underline"
          >
            Notes
          </a>
        )}
        {props.lecture.recordingLink && (
          <a
            href={props.lecture.recordingLink}
            className="text-primary-500 underline"
          >
            Recording
          </a>
        )}
        {props.lecture.liveCodeLink && (
          <a
            href={props.lecture.liveCodeLink}
            className="text-primary-500 underline"
          >
            Livecode
          </a>
        )}
        {props.lecture.otherLinks?.map((otherLink) => (
          <a
            href={otherLink.link}
            target="_blank"
            className="text-primary-500 underline"
          >
            {otherLink.name}
          </a>
        ))}
      </div>
    </div>
  );
}
