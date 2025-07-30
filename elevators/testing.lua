return {
    {
        IFD = "Police station ground close of garage", -- Identifier for developer, really not used in code but for reference.
        CanEnter = {"police", "ambulance"}, -- Can be used by these jobs, or nil for everyone.
        PositionNumber = 1, -- Position number for the elevator, used to identify which position to use when entering or exiting.
        PositionCoords = vec3(459.2114, -1008.0583, 28.2593), -- Coordinates of the elevator position.
        PossibleEntrys = {1, 2, 3}, -- Possible entry positions for the elevator, used to determine where the player can enter from.
    },
    {
        IFD = "Police station balcony",
        CanEnter = nil,
        PositionNumber = 2,
        PositionCoords = vec3(463.6382, -1011.9930, 32.9835),
        PossibleEntrys = {1, 2, 3},
    },
    {
        IFD = "Police station roof",
        CanEnter = nil,
        PositionNumber = 3,
        PositionCoords = vec3(476.2966, -1008.6132, 41.0166),
        PossibleEntrys = {1, 2, 3},
    },
}