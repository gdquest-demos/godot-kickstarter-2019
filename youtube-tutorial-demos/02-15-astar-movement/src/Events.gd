extends Node
"""
Events autoload script for emitting signals.
 
It makes life much easier when we don't have to worry about the paths to different systems/nodes
in order to connect their signals. This also means that all nodes using it will be in direct
interdependency with this Node. This is not much of a problem though. All Nodes and systems
are decoupled which means that if we want to use some component in another project that doesn't
use the same Events class, we can just remove every line with `Events.` in it and we're good to go.
"""


# events emitted by Party members or behaviors attached to these
signal party_member_setup(msg)
signal party_member_walk_started(msg)
signal party_member_walk_finished(msg)

# encounters emit this event when mouse enters over them so they can be correctly interpreted
# as obstacles when trying to move the Party
signal encounter_probed(msg)