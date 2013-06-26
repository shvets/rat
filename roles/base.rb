name "base"

description 'Base Role'

# does not have run list

# common attributes

override_attributes(
    rvm: {:ruby => {version: '1.9.3', implementation: 'ruby', patch_level: 'p392'}}
)
