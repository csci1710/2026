import { staffMember } from "../../SITE_DATA";
import carddecoration from "./card-branch-decoration.png";

export default function StaffMember(member: staffMember) {
  return (
    <div className="md:w-[32rem] md:h-[20rem] relative bg-neutral-50 shadow-md">
      <img
        src={carddecoration}
        alt="Jungle branch decoration"
        className="absolute hidden md:flex"
        style={{ top: "-18px" }}
      />
      <div>
        <img width={"150px"} height={"75px"} src={member.image}></img>
        <p>{member.name}</p>
      </div>
    </div>
  );
}
