local NodeStatus = {
    CURRENT = 0,
    STALE = 1,
    MAYBE_STALE = 2
}

local Node = {}

Node.new = function()
    return {
        fn = nil,
        value = nil,
        status = NodeStatus.STALE,
        parents = {},
        children = {},

        cleanup = function(self)
            for _, parentNode in ipairs(self.parents) do
                for index, childNode in ipairs(parentNode.children) do
                    if (childNode == self) then
                        table.remove(parentNode.children, index)
                        break
                    end
                end
            end
            self.parents = {}
        end
    }
end

local ReactiveState = {
    listeningNode = nil,
    sourceNodes = {},
    effectNodes = {},
    transaction = false
}

local Reactive = {}

Reactive.pushUpdates = function()
    for _, sourceNode in ipairs(ReactiveState.sourceNodes) do
        Reactive.pushSourceNodeUpdate(sourceNode)
    end
    Reactive.pullUpdates()
end

Reactive.pushSourceNodeUpdate = function(sourceNode)
    if (sourceNode.status == NodeStatus.CURRENT) then
        return
    end
    Reactive.pushNodeUpdate(sourceNode)
    for _, childNode in ipairs(sourceNode.children) do
        childNode.status = NodeStatus.STALE
    end
    sourceNode.status = NodeStatus.CURRENT
end

Reactive.pushNodeUpdate = function(node)
    if (node == nil) then
        return
    end
    node.status = NodeStatus.MAYBE_STALE
    for _, childNode in ipairs(node.children) do
        Reactive.pushNodeUpdate(childNode)
    end
end

Reactive.pullUpdates = function()
    for _, effectNode in ipairs(ReactiveState.effectNodes) do
        Reactive.pullNodeUpdates(effectNode)
    end
end

Reactive.pullNodeUpdates = function(node)
    if (node.status == NodeStatus.CURRENT) then
        return
    end
    if (node.status == NodeStatus.MAYBE_STALE) then
        for _, parentNode in ipairs(node.parents) do
            Reactive.pullNodeUpdates(parentNode)
        end
    end
    if (node.status == NodeStatus.STALE) then
        node:cleanup()
        local prevListeningNode = ReactiveState.listeningNode
        ReactiveState.listeningNode = node
        local oldValue = node.value
        node.value = node.fn()
        ReactiveState.listeningNode = prevListeningNode
        for _, childNode in ipairs(node.children) do
            if (oldValue == node.value) then
                childNode.status = NodeStatus.CURRENT
            else
                childNode.status = NodeStatus.STALE
            end
        end
    end
    node.status = NodeStatus.CURRENT
end

Reactive.subscribe = function(node)
    local listeningNode = ReactiveState.listeningNode
    if (listeningNode ~= nil) then
        table.insert(node.children, listeningNode)
        table.insert(listeningNode.parents, node)
    end
end

Reactive.observable = function(initialValue)
    local node = Node.new()
    node.value = initialValue
    node.status = NodeStatus.CURRENT
    local get = function()
        Reactive.subscribe(node)
        return node.value
    end
    local set = function(newValue)
        if (node.value == newValue) then
            return
        end
        node.value = newValue
        node.status = ReactiveState.STALE
        if (not ReactiveState.transaction) then
            Reactive.pushUpdates()
        end
    end
    table.insert(ReactiveState.sourceNodes, node)
    return get, set
end

Reactive.derived = function(fn)
    local node = Node.new()
    node.fn = fn
    return function()
        if (node.status ~= NodeStatus.CURRENT) then
            Reactive.pullNodeUpdates(node)
        end
        Reactive.subscribe(node)
        return node.value
    end
end

Reactive.effect = function(fn)
    local node = Node.new()
    node.fn = fn
    table.insert(ReactiveState.effectNodes, node)
    Reactive.pushUpdates()
end

Reactive.transaction = function(fn)
    ReactiveState.transaction = true
    fn()
    ReactiveState.transaction = false
    Reactive.pushUpdates()
end

Reactive.untracked = function(fn)
    local prevListeningNode = ReactiveState.listeningNode
    ReactiveState.listeningNode = nil
    local value = fn()
    ReactiveState.listeningNode = prevListeningNode
    return value
end

return Reactive
