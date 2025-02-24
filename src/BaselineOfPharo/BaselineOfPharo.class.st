"
This is a primary baseline to load Pharo base libraries, the IDE as well as projects that are managed in own repository (so called ""external projects"") and other
"
Class {
	#name : 'BaselineOfPharo',
	#superclass : 'BaselineOf',
	#classVars : [
		'ExternalProjects'
	],
	#category : 'BaselineOfPharo-Base',
	#package : 'BaselineOfPharo',
	#tag : 'Base'
}

{ #category : 'private' }
BaselineOfPharo class >> declareExternalProjects [

	^ (Pragma allNamed: #externalProject in: self class)
			collect: [ :each | each method valueWithReceiver: self ]
			as: Array
]

{ #category : 'accessing - external projects' }
BaselineOfPharo class >> documentBrowser [
	<externalProject>
	
	^ PharoExternalProject 
		newName: 'DocumentBrowser' 
		owner: 'pharo-spec' 
		project: 'NewTools-DocumentBrowser' 
		version: 'v1.1.0'
]

{ #category : 'repository urls' }
BaselineOfPharo class >> documentBrowserRepository [

	^ (self externalProjectNamed: 'DocumentBrowser') repository
]

{ #category : 'accessing - external projects' }
BaselineOfPharo class >> externalProjectNamed: aName [

	^ self externalProjects 
		detect: [ :each | each name = aName ]
]

{ #category : 'accessing' }
BaselineOfPharo class >> externalProjects [
	<script: 'self externalProjects inspect'>

	^ ExternalProjects ifNil: [ 
		ExternalProjects := self declareExternalProjects ]
]

{ #category : 'accessing - external projects' }
BaselineOfPharo class >> iceberg [
	<externalProject>

	^ PharoExternalProject 
		newName: 'Iceberg' 
		owner: 'pharo-vcs' 
		project: 'iceberg'
		version: 'v2.3.2' 
		sourceDir: nil
]

{ #category : 'repository urls' }
BaselineOfPharo class >> icebergRepository [

	^ (self externalProjectNamed: 'Iceberg') repository
]

{ #category : 'accessing - external projects' }
BaselineOfPharo class >> microdown [
	<externalProject>
	
	^ PharoExternalProject 
		newName: 'Microdown' 
		owner: 'pillar-markup' 
		project: 'Microdown' 
		version: 'v2.6.0'
]

{ #category : 'repository urls' }
BaselineOfPharo class >> microdownRepository [

	^ (self externalProjectNamed: 'Microdown') repository
]

{ #category : 'accessing - external projects' }
BaselineOfPharo class >> newTools [
	<externalProject>

	^ PharoExternalProject 
		newName: 'NewTools' 
		owner: 'pharo-spec' 
		project: 'NewTools' 
		version: 'v0.9.0'
]

{ #category : 'repository urls' }
BaselineOfPharo class >> newToolsRepository [

	^ (self externalProjectNamed: 'NewTools') repository
]

{ #category : 'accessing - external projects' }
BaselineOfPharo class >> roassal [
	<externalProject>

	^ PharoExternalProject
		  newName: 'Roassal'
		  owner: 'pharo-graphics'
		  project: 'Roassal'
		  version: 'v1.06b'
]

{ #category : 'repository urls' }
BaselineOfPharo class >> roassalRepository [

	^ (self externalProjectNamed: 'Roassal') repository
]

{ #category : 'accessing - external projects' }
BaselineOfPharo class >> spec [
	<externalProject>

	^ PharoExternalProject 
		newName: 'Spec2' 
		owner: 'pharo-spec' 
		project:'Spec' 
		version: 'v1.3.3'
]

{ #category : 'repository urls' }
BaselineOfPharo class >> specRepository [

	^ (self externalProjectNamed: 'Spec2') repository
]

{ #category : 'accessing - external projects' }
BaselineOfPharo class >> toplo [
	<externalProject>
	
	^ PharoExternalProject 
		newName: 'Toplo' 
		owner: 'pharo-graphics' 
		project: 'Toplo' 
		version: 'Pharo12'
]

{ #category : 'repository urls' }
BaselineOfPharo class >> toploRepository [

	^ (self externalProjectNamed: 'Toplo') repository
]

{ #category : 'accessing - external projects' }
BaselineOfPharo class >> welcomeBrowser [
	<externalProject>
	
	^ PharoExternalProject 
		newName: 'WelcomeBrowser' 
		owner: 'pharo-spec' 
		project: 'NewTools-WelcomeBrowser' 
		version: 'v1.1.0'
]

{ #category : 'repository urls' }
BaselineOfPharo class >> welcomeBrowserRepository [

	^ (self externalProjectNamed: 'WelcomeBrowser') repository
]

{ #category : 'baselines' }
BaselineOfPharo >> baseline: spec [

	<baseline>
	| repository |
	repository := self packageRepositoryURLForSpec: spec.

	spec for: #common do: [
		spec postLoadDoIt: #postload:package:.
		spec baseline: 'BaseLibraries' with: [ spec repository: repository ].

		spec baseline: 'IDE' with: [ spec repository: repository ].
		spec baseline: 'Calypso' with: [
			spec
				repository: repository;
				loads: #( 'IcebergSupport' ) ].

		spec
			package: 'Gofer-Deprecated';
			package: 'Deprecated12' ]
]

{ #category : 'actions' }
BaselineOfPharo >> postload: loader package: packageSpec [
	"If we added a github token for the build, we remove it."

	Smalltalk os environment at: #GITHUB_TOKEN ifPresent: [ :token |
		| credential |
		credential := (Smalltalk classNamed: #IceCredentialStore) current plaintextCredentialForHostname: 'github.com'.
		credential password = token ifTrue: [ (Smalltalk classNamed: #IceCredentialStore) current removePlainTextCredential: credential ].
		'Removing credential.' traceCr ].

	"Open the WelcomeBrowser as last step"
	(self class environment classNamed: #StWelcomeBrowser)
		ifNotNil: [ :aClass | aClass openForRelease ]
]
