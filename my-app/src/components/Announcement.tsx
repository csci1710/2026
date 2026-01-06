import { MegaphoneIcon, XMarkIcon } from "@heroicons/react/24/outline";
import { useEffect, useState } from "react";

import { announcementInfo } from "../SITE_DATA";

export default function Announcement() {
  const [dismissed, setDismissed] = useState(false);

  useEffect(() => {
    // If the date and time are past the announcementInfo.dismissDate, then
    // automatically set dismissed to true (EASTERN STANDARD TIME)
    const now = new Date();

    // Convert now into EST, if it isn't already
    const nowEST = new Date(
      now.toLocaleString("en-US", {
        timeZone: "America/New_York",
      })
    );

    if (
      nowEST < new Date(announcementInfo.autoReleaseDate) ||
      nowEST > new Date(announcementInfo.autoDismissDate)
    ) {
      setDismissed(true);
    }
  }, []);

  return (
    <>
      {!dismissed && (
        <div className="bg-blue-600">
          <div className="mx-auto max-w-7xl py-3 px-3 sm:px-6 lg:px-8">
            <div className="flex flex-wrap items-center justify-between">
              <div className="flex w-0 flex-1 items-center">
                <span className="flex rounded-lg bg-blue-800 p-2">
                  <MegaphoneIcon
                    className="h-6 w-6 text-white"
                    aria-hidden="true"
                  />
                </span>
                <p className="ml-3 truncate font-medium text-white">
                  <span className="md:hidden">{announcementInfo.message}</span>
                  <span className="hidden md:inline">
                    {announcementInfo.message}
                  </span>
                </p>
              </div>
              <div className="order-3 mt-2 w-full flex-shrink-0 sm:order-2 sm:mt-0 sm:w-auto">
                <a
                  href={announcementInfo.buttonLink}
                  className="flex items-center justify-center rounded-md border border-transparent bg-white px-4 py-2 text-sm font-medium text-blue-600 shadow-sm hover:bg-blue-50"
                >
                  {announcementInfo.buttonText}
                </a>
              </div>
              <div className="order-2 flex-shrink-0 sm:order-3 sm:ml-3">
                <button
                  type="button"
                  className="-mr-1 flex rounded-md p-2 hover:bg-blue-500 focus:outline-none focus:ring-2 focus:ring-white sm:-mr-2"
                  onClick={() => {
                    setDismissed(true);
                  }}
                >
                  <span className="sr-only">Dismiss</span>
                  <XMarkIcon
                    className="h-6 w-6 text-white"
                    aria-hidden="true"
                  />
                </button>
              </div>
            </div>
          </div>
        </div>
      )}
    </>
  );
}
