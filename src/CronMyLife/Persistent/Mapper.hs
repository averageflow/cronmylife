module CronMyLife.Persistent.Mapper where

import CronMyLife.Model
import CronMyLife.Persistent.Entities

mapScheduleOwnerEntityToModel :: ScheduleOwnersEntity -> ScheduleOwner
mapScheduleOwnerEntityToModel x =
  ScheduleOwner
    (scheduleOwnersEntityName x)
    (scheduleOwnersEntityDescription x)
    (scheduleOwnersEntityAvatar x)

mapScheduleOwnerModelToEntity :: ScheduleOwner -> ScheduleOwnersEntity
mapScheduleOwnerModelToEntity x =
  ScheduleOwnersEntity
    (scheduleOwnerName x)
    (scheduleOwnerDescription x)
    (scheduleOwnerAvatar x)