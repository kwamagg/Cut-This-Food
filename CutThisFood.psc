Scriptname CutThisFood extends ReferenceAlias

Actor Property PlayerRef Auto
Keyword Property CTF_Weapons Auto
Keyword Property CTF_Food Auto
Keyword Property CTF_DuplicateRemnantsFood Auto
FormList Property CTF_FoodLists Auto
Bool shouldDouble = False

Event OnInit()
	PO3_Events_Alias.RegisterForWeaponHit(self)
EndEvent

Event OnPlayerLoadGame()
	PO3_Events_Alias.RegisterForWeaponHit(self)
EndEvent

Event OnWeaponHit(ObjectReference akTarget, Form akSource, Projectile akProjectile, Int aiHitFlagMask)
	GoToState("Busy")

	If akTarget.HasKeyword(CTF_DuplicateRemnantsFood)
		shouldDouble = True
	EndIf

	If akTarget.HasKeyword(CTF_Food) && akSource.HasKeyword(CTF_Weapons)
		FormList matchedFormList = CTF_FindMatchingFormList(akTarget, CTF_FoodLists)
		
	        If matchedFormList
			CTF_ReplaceObject(akTarget, matchedFormList)
	        EndIf

	EndIf

	GoToState("")
EndEvent

State Busy
	Event OnWeaponHit(ObjectReference akTarget, Form akSource, Projectile akProjectile, Int aiHitFlagMask)
	EndEvent
EndState

FormList Function CTF_FindMatchingFormList(ObjectReference akTarget, FormList masterList)
	int masterListSize = masterList.GetSize()
	int i = 0
	Form akFood = akTarget.GetBaseObject() as Form

	While i < masterListSize
		FormList currentList = masterList.GetAt(i) as FormList

		If currentList
			If currentList.HasForm(akFood)
				return currentList
			EndIf
        	EndIf

        	i += 1
    	EndWhile

    	Return None
EndFunction

Function CTF_ReplaceObject(ObjectReference akTarget, FormList matchedFormList)
    int listSize = matchedFormList.GetSize()
    int i = 2

    While i < listSize
        Form remnant = matchedFormList.GetAt(i) as Form

        If remnant && shouldDouble
        	akTarget.PlaceAtMe(remnant, 2)
	Elseif remnant && !shouldDouble
		akTarget.PlaceAtMe(remnant, 1)
        EndIf

        i += 1
    EndWhile

    shouldDouble = False
    akTarget.Disable()
    akTarget.Delete()

EndFunction
