import { Assignment, homeworkAssignments } from "../SITE_DATA";
import { classNames } from "../App";

type AssignmentTableProps = {
  tablename: string;
  assignments: { name: string; dateRange: string; href?: string }[];
};

/**
 * Returns whether or not <assignment> should appear as released yet
 * @param assignment the assignment that should or should not be released
 * @return true if "now" is after/on the release date, false otherwise
 */
function shouldRelease(assignment: Assignment): boolean {
  if (assignment.autoReleaseDate === undefined) {
    return true; // If no defined release date, treat it as released if it has an href
  }

  const now = new Date();

  // Convert now into EST, if it isn't already
  const nowEST = new Date(
    now.toLocaleString("en-US", {
      timeZone: "America/New_York",
    }),
  );

  return nowEST > new Date(assignment.autoReleaseDate);
}

export default function AssignmentTable(props: AssignmentTableProps) {
  return (
    <div className="mt-8 flex flex-col">
      <div className="-my-2 -mx-4 overflow-x-auto sm:-mx-6 lg:-mx-8">
        <p className="text-3xl font-title">{props.tablename}</p>
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
                    className="px-3 py-3.5 text-center text-sm font-semibold text-gray-900"
                  >
                    Date
                  </th>
                </tr>
              </thead>
              <tbody className="divide-y divide-gray-200 bg-white">
                {props.assignments.map((assignment) => (
                  <tr key={assignment.name}>
                    {assignment.href && shouldRelease(assignment) ? (
                      <td>
                        <a
                          href={assignment.href}
                          target="_blank"
                          className="whitespace-nowrap py-4 pl-4 pr-3 text-sm font-bold underline sm:pl-6"
                        >
                          {assignment.name}
                        </a>
                      </td>
                    ) : (
                      <td className="whitespace-nowrap py-4 pl-4 pr-3 text-sm font-medium text-gray-400 sm:pl-6">
                        {assignment.name}
                      </td>
                    )}

                    <td className="whitespace-nowrap px-3 py-4 text-sm text-gray-500">
                      {assignment.dateRange}
                    </td>
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
