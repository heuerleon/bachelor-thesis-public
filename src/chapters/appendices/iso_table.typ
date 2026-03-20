#import "../../pages/outline.typ": custom_caption

#figure(
  {
    set text(rgb(50, 50, 50), size: 10pt)
    let spaced-stack(..content) = stack(spacing: 10pt, ..content)
    set table(
      align: (x, y) => if y == 0 { horizon } else { center },
    )
    show strong: it => text(weight: 900, black, it)
    set par(leading: 3pt)

    table(
      columns: 9,
      inset: 4pt,
      stroke: .3pt + black,

      [Functional\ Suitability],
      [Performance\ Efficiency],
      [Compatibility],
      [Interaction\ Capability],
      [Reliability],
      [Security],
      [*Maintainability*],
      [Flexibility],
      [Safety],

      spaced-stack(
        [Functional\ Completeness],
        [Functional\ Correctness],
        [Functional\ Appropriateness],
      ),
      spaced-stack(
        [*Time\ Behaviour*],
        [Resource\ Utilization],
        [Capacity],
      ),
      spaced-stack(
        [Co-existence],
        [Interoperability],
      ),
      spaced-stack(
        [Appropriateness\ Recognizability],
        [Learnability],
        [Operability],
        [User Error\ Protection],
        [User Engagement],
        [Inclusivity],
        [User Assistance],
        [Self-descriptiveness],
      ),
      spaced-stack(
        [*Faultlessness*],
        [Availability],
        [Fault\ Tolerance],
        [Recoverability],
      ),
      spaced-stack(
        [Confidentiality],
        [Integrity],
        [Non-repudiation],
        [Accountability],
        [Authenticity],
        [Resistance],
      ),
      spaced-stack(
        [*Modularity*],
        [*Reusability*],
        [*Analysability*],
        [*Modifiability*],
        [*Testability*],
      ),
      spaced-stack(
        [Adaptability],
        [Scalability],
        [Installability],
        [Replaceability],
      ),
      spaced-stack(
        [Operational\ Constraint],
        [Risk\ Identification],
        [Fail Safe],
        [Hazard Warning],
        [Safe Integration],
      ),
    )
    v(1em)
  },
  caption: custom_caption(
    [Criteria and subcriteria of the SQuaRE quality model according to the ISO/IEC 25010:2023 norm.\ The main criteria are in the header of the table, and each column contains its subcriteria.\ Selected criteria for assessing design patterns are marked in bold.],
    [All criteria from the SQuaRE quality model],
  ),
) <iso-table>
