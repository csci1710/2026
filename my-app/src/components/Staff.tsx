import { professor, htas, utas, gradtas, staffMember } from "../SITE_DATA";
import StaffMember from "./StaffCard/StaffMember";

export default function Staff() {
  return (
    <div className="w-full flex items-center flex-col justify-center">
      <div className="w-full lg:w-1/2 ">
        <h2 className="mb-2 text-3xl font-bold font-title tracking-tight sm:text-4xl">
          Professor
        </h2>
        <h4> tim_nelson@brown.edu </h4>
        <StaffSection staff={[professor]} />
      </div>

      <div className="w-full">
        <h2 className="mb-2 text-3xl font-bold font-title tracking-tight sm:text-4xl">
          HTA
        </h2>
        <h4>cs1710headtas@lists.brown.edu </h4>
        <div className="w-full flex items-center flex-col justify-center">
          <div className="w-full lg:w-1/2 ">
            <StaffSection staff={htas} />
          </div>
        </div>

        <h2 className="mb-2 text-3xl font-bold font-title tracking-tight sm:text-4xl">
          UTAs
        </h2>
        <StaffSection staff={utas} />
        <h2 className="mb-2 text-3xl font-bold font-title tracking-tight sm:text-4xl">
          Grad TAs
        </h2>
        <StaffSection staff={gradtas} />
      </div>
    </div>
  );
}

function StaffSection(props: { staff: staffMember[] }) {
  return (
    <div className="">
      <div className="mx-auto max-w-7xl py-12 px-6 lg:px-8 lg:py-24">
        <div className="space-y-12">
          <ul className="space-y-12 lg:grid lg:grid-cols-2 lg:items-start lg:gap-x-8 lg:gap-y-12 lg:space-y-0">
            {props.staff.map((member: staffMember) => (
              <li
                key={member.name}
                className={props.staff.length === 1 ? "col-span-2" : ""}
              >
                <div className="space-y-4 sm:grid sm:grid-cols-3 sm:gap-6 sm:space-y-0 lg:gap-8">
                  <div className="aspect-w-3 aspect-h-2 h-0 sm:aspect-w-3 sm:aspect-h-4 group relative  shadow-lg rounded-lg">
                    {/* If the alt portrait doesn't exist, just show the regular image */}
                    <img
                      className="absolute rounded-lg object-cover"
                      src={member.alt_image ? member.alt_image : member.image}
                      // Fix image alignment if necessary
                      style={{
                        objectPosition: member.alt_image
                          ? member.alt_objectPosition
                          : member.objectPosition,
                      }}
                      alt={"Alternate portrait of " + member.name}
                    />

                    <img
                      className={
                        "group-hover:hidden absolute rounded-lg object-cover "
                      }
                      src={member.image}
                      // Fix image alignment if necessary
                      style={{ objectPosition: member.objectPosition }}
                      alt="Staff portrait of {member.name}"
                    />
                  </div>
                  <div className="sm:col-span-2">
                    <div className="space-y-4">
                      <div className="space-y-1 text-lg font-medium leading-6">
                        <h3 className="text-4xl font-subtitle">
                          {member.name}
                        </h3>
                        <h4 className="text-neutral-500">{member.pronouns}</h4>
                        {/* <p className="text-primary-600">{member.role}</p> */}
                      </div>
                      <div className="text-lg">
                        <p className="text-gray-500">{member.bio}</p>
                      </div>
                      <div className="text-sm text-gray-500">
                        <p className="font-light">
                          {" "}
                          <span
                            className="font-bold"
                            style={{ color: "#2c7d39" }}
                          >
                            {member.favorite_amphibian}
                          </span>
                        </p>
                      </div>
                    </div>
                  </div>
                </div>
              </li>
            ))}
          </ul>
        </div>
      </div>
    </div>
  );
}
