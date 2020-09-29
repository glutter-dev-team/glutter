
bool valuesHaveChanged(Map values) {

    bool changed = false;
    values.forEach((key, value) {
        if(key != value) {
            changed = true;
        }
    });

    return changed;
}