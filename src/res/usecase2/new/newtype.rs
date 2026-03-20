pub(super) struct ValidatedDreson(String);
impl ValidatedDreson {
    pub fn from_string(dreson: String, exceptions: &[String]) -> anyhow::Result<Self> {
        if is_valid_dreson(&dreson) || exceptions.contains(&dreson) {
            Ok(ValidatedDreson(dreson))
        } else {
            Err(anyhow::anyhow!("Invalid dreson format"))
        }
    }
}