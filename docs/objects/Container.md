Container is the base class for all frame types. It provides the basic structure and functionality for all frame objects. Container objects can contain other container objects, thus forming the foundation for the hierarchy of frame objects.

In addition to the Object and VisualObject methods, container objects have the following methods:

|   |   |
|---|---|
|[addChild](objects/Container/addChild.md)|Adds a new object to the container
|[getChild](objects/Container/getChild.md)|Returns an object in the container by its ID
|[getDeepChild](objects/Container/getDeepChild.md)|Returns an object in the container or its sub-containers by its ID
|[removeChild](objects/Container/removeChild.md)|Removes an object from the container by its ID
|[removeChildren](objects/Container/removeChildren.md)|Removes all children object's
|[updateZIndex](objects/Container/updateZIndex.md)|Updates the Z-index of an object in the container
|[setImportant](objects/Container/setImportant.md)|Marks an object as important, so it is displayed on top if needed
|[sortElementOrder](objects/Container/sortElementOrder.md)|Sorts the order of elements in the container based on their Z-indices
|[clearFocusedChild](objects/Container/clearFocusedChild.md)|Removes focus from an object in the container
|[setFocusedChild](objects/Container/setFocusedChild.md)|Sets focus on a specific object in the container

A Container Object inherits from VisualObject, but won't draw children objects.
