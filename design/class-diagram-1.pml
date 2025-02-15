@startuml

package objects {

class StoredObjectsJcsCacheActor <<ObjectsGetter>> <<ObjectsSetter>>

StoredObjectsJcsCacheActor o--> "0-*" GameObject : caches >

abstract GameObject <<Externalizable>> <<StreamStorage>> {
id
}
abstract GameMapObject <<StoredObject>> {
pos
}
abstract Vegetation
abstract GameMovingObject

class GameMap <<StoredObject>> {
filledChunks
filledBlocks
}
class WorldMap <<StoredObject>>
class MapObject {
id
cid
LongIntMap oids
}

WorldMap o..> GameMap : "indirect: currentMap"
GameMap o..> WorldMap : "indirect: world"

GameObject <|-- GameMap
GameObject <|- WorldMap
GameObject <|-- GameMapObject
GameObject <|-- MapObject

GameMapObject <|-- Vegetation
GameMapObject <|-- GameMovingObject
GameMapObject o--> GameMap : "indirect: map"

Vegetation <|-- Grass
Vegetation <|-- Shrub
Vegetation <|-- Tree
Vegetation <|-- TreeSapling

}
' package objects

package maps {

class MapObjectsJcsCacheActor <<ObjectsGetter>> <<ObjectsSetter>> {
{static} setMapObject(ObjectsSetter os, MapObject mo)
{static} getMapObject(ObjectsGetter og, GameMap gm, GameBlockPos pos)
{static} getMapObject(ObjectsGetter og, GameMap gm, int x, int y, int z)
{static} getMapObject(ObjectsGetter og, int index)
}

MapObjectsJcsCacheActor o--> "0-*" MapObject : caches >

class MapChunk
class MapBlock

MapObject o.. "1" MapChunk : "indirect: cid"

MapObject o.. "0-*" GameMapObject : "indirect: oid"

class MapChunksJcsCacheActor <<ObjectsGetter>> <<ObjectsSetter>>

MapChunksJcsCacheActor o--> "0-*" MapChunk : caches >
MapChunk *--> "*" MapBlock

class ObjectsActor

ObjectsActor x..> StoredObjectsJcsCacheActor : uses >
ObjectsActor x..> MapChunksJcsCacheActor : uses >
ObjectsActor x..> MapObjectsJcsCacheActor : uses >

ObjectsActor x..> InsertObjectMessage : receives >
ObjectsActor x..> DeleteObjectMessage : receives >

class MapObjectsLmbdStorage <<MapObjectsStorage>> <<ObjectsGetter>> <<ObjectsSetter>>

MapObjectsJcsCacheActor --> MapObjectsLmbdStorage : uses >

MapObjectsLmbdStorage *--> "0-*" MapObject : "indirect: id"

}
' package maps

package knowledge {

class PowerLoomKnowledgeActor <<KnowledgeGetter>>

class KnowledgeJcsCacheActor <<ObjectsGetter>> <<ObjectsSetter>>

abstract KnowledgeLoadedObject

GameObject <|--- KnowledgeLoadedObject

PowerLoomKnowledgeActor o--> "0-*" KnowledgeLoadedObject : retrieves >

abstract KnowledgeObject

GameObject <|- KnowledgeObject

KnowledgeLoadedObject *--> "0-*" KnowledgeObject : contains >

KnowledgeObject x--> "1" GameObject : creates >

KnowledgeJcsCacheActor o--> "0-*" KnowledgeLoadedObject : caches >

KnowledgeJcsCacheActor o--> "0-*" KnowledgeObject : caches >

PowerLoomKnowledgeActor o--> "1" KnowledgeJcsCacheActor : uses >

}
' package knowledge

'class MaterialAssetsCacheActor

'class ModelsAssetsCacheActor

@enduml
