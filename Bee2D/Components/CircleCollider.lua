-- CircleCollider.lua

local CircleCollider = {}
CircleCollider.__index = CircleCollider

function CircleCollider.new(collisionRadius, owner)
	local self = setmetatable({}, CircleCollider)
	self.owner = owner
	self.colliderType = "CIRCLE"
	self.collisionRadius = collisionRadius
	return self
end

function CircleCollider:checkCollisionCircle(otherCollider)
	if otherCollider.owner == self.owner then
		return false
	end
	local combinedRadii = otherCollider.collisionRadius + self.collisionRadius
	local distance = (otherCollider.owner.Transform.WorldPosition - self.owner.Transform.WorldPosition).magnitude
	return distance <= combinedRadii
end

function CircleCollider:checkCollisionAABB(otherCollider)
	if otherCollider.owner == self.owner then
		return false
	end
	local direction = self.owner.Transform.WorldPosition - otherCollider.owner.Transform.WorldPosition
	direction.X = direction.X < -otherCollider.width / 2 and -otherCollider.width or direction.X
	direction.X = direction.X > otherCollider.width / 2 and otherCollider.width or direction.X
	direction.Y = direction.Y < -otherCollider.height / 2 and -otherCollider.height or direction.Y
	direction.Y = direction.Y > otherCollider.height / 2 and otherCollider.height or direction.Y
	local closestPoint = otherCollider.owner.Transform.WorldPosition + direction
	local distanceFromClosestPoint = (self.owner.Transform.WorldPosition - closestPoint).magnitude
	if distanceFromClosestPoint <= self.collisionRadius then
		return true
	end
	return false
end

return CircleCollider